# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

TOOLCHAIN_PATH = "${DEPLOY_DIR}/sdk"
SDK_PN = "qirp-sdk"
SDK_VERSION = "2.4.0"
OSS_CHANNEL_FLAG = "${@bb.utils.contains_any('BBFILE_COLLECTIONS', 'qcom-robotics-extras', 'false', 'true', d)}"

# Function: process_toolchain
process_toolchain() {
    bbnote "Processing toolchain..."
    if ls ${TOOLCHAIN_PATH}/* | xargs -n1 basename | grep ${TOOLCHAIN_OUTPUTNAME} >/dev/null 2>&1; then
        bbnote "Standard SDK Toolchain found in ${TOOLCHAIN_PATH}, copy to ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/toolchain/"
        install -d ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/toolchain
        find ${TOOLCHAIN_PATH} -type f -name "${TOOLCHAIN_OUTPUTNAME}*" -exec cp {} ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/toolchain/ \;
    else
        bbwarn "No Standard SDK Toolchain found in ${TOOLCHAIN_PATH}, Please Note it!"
    fi
}

# Function: process_setup.sh
process_setup_sh() {
    bbnote "Processing setup.sh..."
    SETUP_SH_PATH="${ROBIOTICS_LAYER_DIR}/recipes-sdk/files/setup.sh"
    if [ -f "${SETUP_SH_PATH}" ]; then
        bbnote "setup.sh found in ${SETUP_SH_PATH}, copy to ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/"
        install -d ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/
        cp ${SETUP_SH_PATH} ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/
    else
        bbwarn "No setup.sh found in ${SETUP_SH_PATH}, Please Note it!"
    fi
}

process_qir_samples() {
    bbnote "Processing QIR samples..."
    
    # Process the files in the content_config.json
    CONFIG_FILE="${ROBIOTICS_LAYER_DIR}/recipes-sdk/files/content_config.json"
    if [ ! -f "${CONFIG_FILE}" ]; then
        bbwarn "Config file ${CONFIG_FILE} not found, skipping samples processing"
        return
    fi
    
    jq -c '.samples[]' $CONFIG_FILE | while read line; do
        name=$(echo $line | jq -r '.name')
        oss_channel=$(echo $line | jq -r '.oss_channel')
        from_uri=$(echo $line | jq -r '.from_uri')
        branch=$(echo $line | jq -r '.branch')
        src_rev=$(echo $line | jq -r '.src_rev')
        individual_prj=$(echo $line | jq -r '.individual_prj')
        from_local="$(echo $line | jq -r '.from_local')"
        to="${QIRP_SSTATE_IN_DIR}/${SDK_PN}/$(echo $line | jq -r '.to')"

        bbnote "  Processing sample: $name"
        bbnote "  oss_channel: $oss_channel, OSS_CHANNEL_FLAG: ${OSS_CHANNEL_FLAG}"
        bbnote "  from_uri: $from_uri"
        bbnote "  src_rev: $src_rev"
        bbnote "  Target path (to): $to"

        # Use test command instead of [[ ]]
        if [ "$oss_channel" = "false" ] && [ "$oss_channel" != "${OSS_CHANNEL_FLAG}" ]; then
            bbwarn "Skipping $name cause of channel mismatch ..."
            continue
        fi

        if [ -n "$from_uri" ] && [ "$from_uri" != "null" ]; then
            # Special handling for qrb_ros_samples
            if echo "$from_uri" | grep -q "qrb_ros_samples"; then
                bbnote "Detected qrb_ros_samples repository"
                if [ -z "${QRB_ROS_SAMPLE_REV}" ]; then
                    bbwarn "QRB_ROS_SAMPLE_REV is not set, using original src_rev: $src_rev"
                else
                    src_rev="${QRB_ROS_SAMPLE_REV}"
                    bbnote "Using QRB_ROS_SAMPLE_REV: $src_rev"
                fi
            fi
            
            if [ "$individual_prj" = "false" ]; then
                # For non-individual projects, clone to temp directory and copy specific subdirectory
                bbnote "$name: cloning to temp directory (individual_prj=false)"
                tempdir=$(mktemp -p ${TOPDIR} -d)
                
                # Clone to temp directory
                if git clone -b $branch $from_uri $tempdir; then
                    cd $tempdir/
                    if git checkout $src_rev; then
                        cd -
                        # Ensure target directory exists
                        install -d $to
                        # Find and copy the specific subdirectory
                        if find $tempdir/ -name "$name" -type d -prune -exec cp -r {} $to \;; then
                            bbnote "Successfully copied $name from $tempdir to $to"
                        else
                            bbwarn "Could not find $name in cloned repository at $tempdir"
                        fi
                    else
                        bbwarn "Failed to checkout $src_rev for $name"
                    fi
                else
                    bbwarn "Failed to clone $from_uri for $name"
                fi
                # Clean up temp directory
                rm -rf $tempdir
            else
                # For individual projects, create target directory and clone directly
                bbnote "$name: cloning as individual project (individual_prj=true)"
                install -d $to
                if git clone -b $branch $from_uri $to$name; then
                    cd $to$name
                    if git checkout $src_rev; then
                        cd -
                        bbnote "Successfully cloned and checked out $name"
                    else
                        bbwarn "Failed to checkout $src_rev for $name"
                    fi
                else
                    bbwarn "Failed to clone $from_uri for $name"
                fi
            fi
            continue
        fi

        # Handle local source copying
        if [ -d "${TOPDIR}/$from_local$name" ]; then
            bbnote "Copy sample source from ${TOPDIR}/$from_local$name to $to"
            install -d $to
            cp -r ${TOPDIR}/$from_local$name $to
        fi
    done

    # Process scripts from config file
    jq -c '.scripts[]' $CONFIG_FILE | while read line; do
        name=$(echo $line | jq -r '.name')
        from_local="${ROBIOTICS_LAYER_DIR}/recipes-sdk/files/$(echo $line | jq -r '.from_local')"
        to="${QIRP_SSTATE_IN_DIR}/${SDK_PN}/$(echo $line | jq -r '.to')"

        if [ -d "$from_local$name" ]; then
            # Ensure target directory exists
            install -d $(dirname "$to")
            cp -r "$from_local$name" "$to"
            bbnote "Copy sample source from $from_local$name to $to"
        else
            bbwarn "Source directory $from_local$name does not exist, skipping"
        fi
    done

    # Process sample.json
    SAMPLE_JSON="${ROBIOTICS_LAYER_DIR}/recipes-sdk/files/samples.json"
    if [ -n "$SAMPLE_JSON" ] && [ -f "$SAMPLE_JSON" ]; then
        # Ensure target directory exists
        install -d ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/qirp-samples/
        cp "$SAMPLE_JSON" ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/qirp-samples/
        bbnote "Copied samples.json to ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/qirp-samples/"
    fi
}

# Function: process_runtime
process_runtime() {
    bbnote "Processing runtime packages for ${PN}..."
    
    INSTALL_SCRIPT_PATH="${ROBIOTICS_LAYER_DIR}/recipes-sdk/files/install.sh"
    UNINSTALL_SCRIPT_PATH="${ROBIOTICS_LAYER_DIR}/recipes-sdk/files/uninstall.sh"
    QIRP_UPGRADE_PATH="${ROBIOTICS_LAYER_DIR}/recipes-sdk/files/qirp-upgrade.sh"

    # Create runtime directories under SDK_PN
    bbnote "Creating runtime package directory"
    install -d ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/runtime/packages
    install -d ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/runtime/scripts

    # Copy script files if they exist
    for script_file in "${INSTALL_SCRIPT_PATH}" "${UNINSTALL_SCRIPT_PATH}" "${QIRP_UPGRADE_PATH}"; do
        if [ -f "${script_file}" ]; then
            bbnote "Copying ${script_file} to ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/runtime/scripts/"
            cp "${script_file}" ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/runtime/scripts/
        else
            bbwarn "Script file ${script_file} not found, skipping"
        fi
    done

    if ls ${DEPLOY_DIR}/${IMAGE_PKGTYPE}/${PACKAGE_ARCH}/${PN}_*.${IMAGE_PKGTYPE} >/dev/null 2>&1; then
        cp ${DEPLOY_DIR}/${IMAGE_PKGTYPE}/${PACKAGE_ARCH}/${PN}_*.${IMAGE_PKGTYPE} ${QIRP_SSTATE_IN_DIR}/${SDK_PN}/runtime/packages/
    else
        bbwarn "no ${PN} package generated at ${DEPLOY_DIR}/${IMAGE_PKGTYPE}/${PACKAGE_ARCH}, please double check"
    fi
}

# Main function: do_generate_qirp_sdk
do_generate_qirp_sdk(){
    bbnote "Starting QIRP SDK generation..."
    
    # Create base SDK directory structure
    bbnote "Creating base SDK directory: ${QIRP_SSTATE_IN_DIR}/${SDK_PN}"
    install -d ${QIRP_SSTATE_IN_DIR}/${SDK_PN}
    
    # 1. Process toolchain
    process_toolchain
    
    # 2. Process setup.sh
    process_setup_sh
    
    # 3. Process QIRP samples
    process_qir_samples
    
    # 4. Process runtime packages
    process_runtime

    # Create final SDK package
    cd ${QIRP_SSTATE_IN_DIR}
    tar -zcf ${QIRP_SSTATE_IN_DIR}/${SDK_PN}_${SDK_VERSION}.tar.gz ./${SDK_PN}/*
    
    # Clean up temporary directories
    rm -rf ${QIRP_SSTATE_IN_DIR}/${SDK_PN}
    
    bbnote "QIRP SDK generation completed: ${QIRP_SSTATE_IN_DIR}/${SDK_PN}_${SDK_VERSION}.tar.gz"
}

SSTATETASKS += "do_generate_qirp_sdk "
QIRP_SSTATE_OUT_DIR = "${DEPLOY_DIR}/qirpsdk_artifacts/${MACHINE}/"
QIRP_SSTATE_IN_DIR = "${DEPLOY_DIR}/factory/"

do_generate_qirp_sdk[sstate-inputdirs] = "${QIRP_SSTATE_IN_DIR}"
do_generate_qirp_sdk[sstate-outputdirs] = "${QIRP_SSTATE_OUT_DIR}"
do_generate_qirp_sdk[dirs] = "${QIRP_SSTATE_IN_DIR} ${QIRP_SSTATE_OUT_DIR}"
do_generate_qirp_sdk[cleandirs] = "${QIRP_SSTATE_OUT_DIR}"
do_generate_qirp_sdk[stamp-extra-info] = "${MACHINE_ARCH}"

python do_generate_qirp_sdk_setscene () {
    sstate_setscene(d)
}
addtask do_generate_qirp_sdk_setscene

do_generate_qirp_sdk[depends] += "jq-native:do_populate_sysroot git-native:do_populate_sysroot"
addtask do_generate_qirp_sdk after do_populate_sdk
