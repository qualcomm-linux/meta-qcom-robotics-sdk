# Copyright (c) 2023-2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

SSTATETASKS += "do_generate_product_sdk "
SSTATE_OUT_DIR = "${QIRP_OUTPUT}"
SSTATE_IN_DIR = "${TOPDIR}/${SDK_PN}"
TMP_SSTATE_IN_DIR = "${TOPDIR}/${SDK_PN}_tmp"
SAMPLES_PATH ?= "NULL"
TOOLCHAIN_PATH ?= "NULL"
TOOLS_PATH ?= "NULL"
README_PATH ?= "NULL"
SETUP_PATH ?= "NULL"
ARTIFACTS_PATH ?= "artifacts"

python __anonymous () {
    package_type = d.getVar("IMAGE_PKGTYPE", True)
    package_generate_task = 'do_package_write_{}'.format(package_type)
    bb.build.addtask(package_generate_task, 'do_populate_sysroot', 'do_packagedata', d)
    bb.build.addtask('do_generate_product_sdk', 'do_populate_sysroot', package_generate_task, d)
    rdepends = d.getVar("RDEPENDS:{}".format(d.getVar("PN")))
    function_sdk_list = rdepends.split() if rdepends else []
    for function_sdk in function_sdk_list:
        d.appendVarFlag("do_generate_product_sdk", 'depends', ' {}:do_generate_artifacts '.format(function_sdk))
}

addtask do_generate_product_sdk_setscene
do_generate_product_sdk[postfuncs] += "organize_sdk_file"
do_generate_product_sdk[sstate-inputdirs] = "${SSTATE_IN_DIR}"
do_generate_product_sdk[sstate-outputdirs] = "${SSTATE_OUT_DIR}"
do_generate_product_sdk[dirs] = "${SSTATE_IN_DIR} ${SSTATE_OUT_DIR} ${TMP_SSTATE_IN_DIR}"
do_generate_product_sdk[cleandirs] = "${SSTATE_IN_DIR} ${SSTATE_OUT_DIR} ${TMP_SSTATE_IN_DIR}"
do_generate_product_sdk[stamp-extra-info] = "${MACHINE_ARCH}"
do_generate_product_sdk[nostamp] = "1"
do_generate_product_sdk[network] = "1"

RUNTIME_SCRIPTS = "install.sh uninstall.sh qirp-upgrade.sh"
# Add a task to generate product sdk
do_generate_product_sdk () {
    # generate Product SDK package
    if [ ! -d ${TMP_SSTATE_IN_DIR}/${SDK_PN}/runtime ]; then
        bbnote " creating qirp-sdk temp workdir ${TMP_SSTATE_IN_DIR} included subdir scripts , packages "
        mkdir -p ${TMP_SSTATE_IN_DIR}/${SDK_PN}/runtime/packages
        mkdir -p ${TMP_SSTATE_IN_DIR}/${SDK_PN}/runtime/scripts
    fi

    bbnote " copy workspace scripts install.sh uninstall.sh qirp-upgrade.sh from ${WORKDOR}to target workdir "
    for script in ${RUNTIME_SCRIPTS}; do
        if [ -e "${WORKDIR}/${script}" ]; then
            cp "${WORKDIR}/${script}" ${TMP_SSTATE_IN_DIR}/${SDK_PN}/runtime/scripts
        else
            bbwarn "${script} not exist in ${WORKDIR} , double check please"
        fi
    done

    if ls ${DEPLOY_DIR}/${IMAGE_PKGTYPE}/${PACKAGE_ARCH}/${PN}_*.${IMAGE_PKGTYPE} >/dev/null 2>&1; then
        cp ${DEPLOY_DIR}/${IMAGE_PKGTYPE}/${PACKAGE_ARCH}/${PN}_*.${IMAGE_PKGTYPE} ${TMP_SSTATE_IN_DIR}/${SDK_PN}/runtime/packages/
    else
        bbwarn "no ${PN} package generated at ${DEPLOY_DIR}/${IMAGE_PKGTYPE}/${PACKAGE_ARCH}, please double check"
    fi

    bbnote " copy target package ${DEPLOY_DIR}/${ARTIFACTS_PATH}/*/packages/* from to target workdir "
    if ls ${DEPLOY_DIR}/${ARTIFACTS_PATH}/*/packages/* >/dev/null 2>&1; then
        bbnote "Function-sdk packages found in ${DEPLOY_DIR}/${ARTIFACTS_PATH} , copying"
        cp ${DEPLOY_DIR}/${ARTIFACTS_PATH}/*/packages/*.${IMAGE_PKGTYPE} ${TMP_SSTATE_IN_DIR}/${SDK_PN}/runtime/packages/
    else
        bbwarn "No function-sdk packages found in ${DEPLOY_DIR}/${ARTIFACTS_PATH}, QIRP-SDK Could be empty!"
    fi

    cd ${TMP_SSTATE_IN_DIR}
    bbnote "packaged workdir runtime to ${SDK_PN}.tar.gz "
    tar -zcf ${SSTATE_IN_DIR}/${SDK_PN}.tar.gz -C ${TMP_SSTATE_IN_DIR}/${SDK_PN}/runtime .

    if [ ! -d ${SSTATE_IN_DIR}/${SDK_PN}/runtime ]; then
        install -d  ${SSTATE_IN_DIR}/${SDK_PN}/runtime
    fi
}

# Add a task to copy sample code/toolchain/setup scripts,
# and orgnanize as finial sdk artifact
organize_sdk_file () {
    # orgnanize runtime packages
    if ls ${SSTATE_IN_DIR}/${SDK_PN}* >/dev/null 2>&1; then
        bbnote "Found runtime package"
        mv ${SSTATE_IN_DIR}/${SDK_PN}*.tar.gz ${SSTATE_IN_DIR}/${SDK_PN}/runtime/
    else
        bbfatal "No ${SDK_PN} packages generated, Robotics SDK functions will be missed! Please check and retry!"
    fi

    # orgnanize QIRP sample codes
    CONFIG_FILE="${WORKDIR}/${CONFIGFILE}"
    sed -i "s/CUST_ID/${CUST_ID}/g" ${CONFIG_FILE}
    jq -c '.samples[]' $CONFIG_FILE | while read line; do
        name=$(echo $line | jq -r '.name')
        oss_channel=$(echo $line | jq -r '.oss_channel')
        from_uri=$(echo $line | jq -r '.from_uri')
        branch=$(echo $line | jq -r '.branch')
        individual_prj=$(echo $line | jq -r '.individual_prj')
        from_local="$(echo $line | jq -r '.from_local')"
        to="${SSTATE_IN_DIR}/${SDK_PN}/$(echo $line | jq -r '.to')"

        if [[ "$oss_channel" == "false" && "$oss_channel" != "${OSS_CHANNEL_FLAG}" ]]; then
            bbnote "Skipping $name cause of channel mismatch ..."
            continue
        fi

        #create destination dir
        install -d $to

        if [[ -n "$from_uri" && "$from_uri" != "null" ]]; then
            # if "$individual_prj" == "false", that more than one feature include in this project
            if [[ "$individual_prj" == "false" ]]; then
                tempdir=$(mktemp -p ${WORKSPACE} -d)
                bbnote "$name downloading: git clone -b $branch $from_uri $tempdir"
                git clone -b $branch $from_uri $tempdir
                find $tempdir -name "$name" -type d -prune -exec cp -r {} $to \;
                rm -rf $tempdir
            else
                bbnote "$name downloading: git clone -b $branch $from_uri $to$name"
                git clone -b $branch $from_uri $to$name
            fi
            continue
        fi

        if [ -d "${WORKSPACE}/$from_local$name" ]; then
            bbnote "Copy sample source from ${WORKSPACE}/$from_local$name to $to"
            cp -r ${WORKSPACE}/$from_local$name $to
        fi

    done

    #orgnanize QIRP sample.json
    SAMPLE_JESON="${WORKDIR}/samples.json"
    if [ -n "$SAMPLE_JESON" ]; then
        cp $SAMPLE_JESON ${SSTATE_IN_DIR}/${SDK_PN}/qirp-samples/
    fi

    jq -c '.scripts[]' $CONFIG_FILE | while read line; do
         name=$(echo $line | jq -r '.name')
         from_local="${WORKDIR}/$(echo $line | jq -r '.from_local')"
         to="${SSTATE_IN_DIR}/${SDK_PN}/$(echo $line | jq -r '.to')"

         if [ -d "$from_local$name" ]; then
             cp -r $from_local$name $to
             bbnote "Copy sample source from $from_local$name to $to"
         fi
    done

    # orgnanize tools
    if ls ${TOOLS_PATH}/* >/dev/null 2>&1; then
        install -d ${SSTATE_IN_DIR}/${SDK_PN}/tools
        cp -r ${TOOLS_PATH}/* ${SSTATE_IN_DIR}/${SDK_PN}/tools/
    else
        bbwarn "No Tools found in ${TOOLS_PATH}, Please Note it!"
    fi

    # orgnanize README docs
    if ls ${README_PATH} >/dev/null 2>&1; then
        cp -r ${README_PATH} ${SSTATE_IN_DIR}/${SDK_PN}/
    else
        bbwarn "No README docs found in ${README_PATH}, Please Note it!"
    fi

    # orgnanize setup.sh script
    if ls ${SETUP_PATH} >/dev/null 2>&1; then
        cp -r ${SETUP_PATH} ${SSTATE_IN_DIR}/${SDK_PN}/
    else
        bbwarn "No setup.sh script found in ${SETUP_PATH}, Please Note it!"
    fi
}

python do_generate_product_sdk_setscene() {
    sstate_setscene(d)
}
