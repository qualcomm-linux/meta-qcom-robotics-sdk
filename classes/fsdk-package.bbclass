# Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

SSTATETASKS += "do_generate_robotics_sdk "

SSTATE_OUT_DIR = "${DEPLOY_DIR}/${TARGET_SDK}sdk_artifacts/"

SSTATE_IN_DIR = "${TOPDIR}/${SDK_PN}"
TMP_SSTATE_IN_DIR = "${TOPDIR}/${SDK_PN}_tmp"

SAMPLES_PATH ?= "NULL"
TOOLCHAIN_PATH ?= "NULL"
TOOLS_PATH ?= "NULL"
README_PATH ?= "NULL"
SETUP_PATH ?= "NULL"
PACKAGE_ARCH = "${SOC_ARCH}"

TARGET_SDK ?= "robotics"
SDK_PN = "${TARGET_SDK}-sdk"

python __anonymous () {
    import oe.packagedata
    package_type = d.getVar("IMAGE_PKGTYPE", True)
    recipe_name = d.getVar("PN")
    bb.build.addtask('do_package_write_{}'.format(package_type), 'do_populate_sysroot', 'do_packagedata', d)
    bb.build.addtask('do_generate_robotics_sdk', 'do_populate_sysroot', 'do_package_write_{}'.format(package_type), d)
    d.appendVarFlag('do_package_write_{}'.format(package_type), 'prefuncs', ' do_reorganize_pkg_dir')

    for pkg in str(d.getVar('RDEPENDS:{}'.format(recipe_name))).split():
        suffixes = ("-dev", "-doc", "-staticdev", "-dbg")
        package_name = ""
        for suffix in suffixes:
            if pkg.endswith(suffix):
                package_name = pkg[:-len(suffix)]
        if package_name == "":
            package_name = pkg
        recipe_name_pkg = ""
        sdata = oe.packagedata.read_subpkgdata(pkg, d)
        if 'PN' not in sdata.keys():
            bb.note("{} not in database".format(package_name))
            recipe_name_pkg = package_name
        else:
            recipe_name_pkg = sdata['PN']
        if package_name not in d.getVar("BASIC_DEPENDENCY"):
            d.appendVarFlag('do_generate_robotics_sdk', 'depends', ' {}:do_package_write_{} '.format(recipe_name_pkg,package_type))
}

addtask do_generate_robotics_sdk_setscene
do_generate_robotics_sdk[postfuncs] += "organize_sdk_file"
do_generate_robotics_sdk[sstate-inputdirs] = "${SSTATE_IN_DIR}"
do_generate_robotics_sdk[sstate-outputdirs] = "${SSTATE_OUT_DIR}"
do_generate_robotics_sdk[dirs] = "${SSTATE_IN_DIR} ${SSTATE_OUT_DIR} ${TMP_SSTATE_IN_DIR}"
do_generate_robotics_sdk[cleandirs] = "${SSTATE_IN_DIR} ${SSTATE_OUT_DIR} ${TMP_SSTATE_IN_DIR}"
do_generate_robotics_sdk[stamp-extra-info] = "${MACHINE_ARCH}"

PKG_LISTS += "${@pkg_list(d)}"
PKG_LISTS += "${PN}_${PV}-${PR}_${ROBOTICS_ARCH}.${IMAGE_PKGTYPE}"

def pkg_list(d):
    recipe_name = d.getVar("PN")
    import oe.packagedata
    pkglist = str()
    for pkg in str(d.getVar('RDEPENDS:{}'.format(recipe_name))).split():
        if pkg in d.getVar("BASIC_DEPENDENCY"):
            continue
        sdata = oe.packagedata.read_subpkgdata(pkg, d)
        package_name = pkg
        if 'PN' not in sdata.keys():
            continue
        package_version = sdata['PKGV']
        package_reversion = sdata['PKGR']
        recipe_name = sdata['PN']
        package_arch = d.getVar("ROBOTICS_ARCH")
        package_type = d.getVar("IMAGE_PKGTYPE")
        package = " *{}_{}-{}_{}.{} ".format(package_name,package_version,package_reversion,package_arch,package_type)
        pkglist += package
    return pkglist

def depends_funcs(d):
    import oe.packagedata
    package_type = d.getVar("IMAGE_PKGTYPE", True)
    recipe_name = d.getVar("PN")
    depends = ""
    for pkg in str(d.getVar('RDEPENDS:{}'.format(recipe_name))).split():
        sdata = oe.packagedata.read_subpkgdata(pkg, d)
        package_name = pkg
        if 'PN' not in sdata.keys():
            continue
        recipe_name = sdata['PN']
        depends += ' {}:do_package_write_{} '.format(recipe_name,package_type)
    bb.warn("depends: %s" %depends)
    return depends


# Add a task to generate robotics sdk
do_generate_robotics_sdk () {
    # generate Robotics SDK package
    if [ ! -d ${TMP_SSTATE_IN_DIR}/${SDK_PN} ]; then
        bbnote "create directory ${TMP_SSTATE_IN_DIR}/${SDK_PN}"
        mkdir -p ${TMP_SSTATE_IN_DIR}/${SDK_PN}/
    fi
    #bbnote "copy file from ${SETUP_PATH} to ${TMP_SSTATE_IN_DIR}/${SDK_PN}"
    #cp -r ${SETUP_PATH} ${TMP_SSTATE_IN_DIR}/${SDK_PN}/
    for pkg in ${PKG_LISTS}
    do
        bbnote "copy file from ${DEPLOY_DIR}/${IMAGE_PKGTYPE}/${PACKAGE_ARCH}/${pkg} to ${TMP_SSTATE_IN_DIR}/${SDK_PN}"
        cp ${DEPLOY_DIR}/${IMAGE_PKGTYPE}/${PACKAGE_ARCH}/${pkg} ${TMP_SSTATE_IN_DIR}/${SDK_PN}/
    done
    cd ${TMP_SSTATE_IN_DIR}
    bbnote "make tarball ${SDK_PN}.tar.gz from ${TMP_SSTATE_IN_DIR}/${SDK_PN}"
    tar -zcf ${SSTATE_IN_DIR}/${SDK_PN}.tar.gz ./${SDK_PN}
}

# Add a task to copy sample code/toolchain/setup scripts,
# and orgnanize as finial sdk artifact
organize_sdk_file () {
    # orgnanize runtime packages
    if ls ${SSTATE_IN_DIR}/${SDK_PN}* >/dev/null 2>&1; then
        install -d ${SSTATE_IN_DIR}/${SDK_PN}/runtime
        mv ${SSTATE_IN_DIR}/${SDK_PN}*.tar.gz ${SSTATE_IN_DIR}/${SDK_PN}/runtime/
    else
        bbfatal "No ${SDK_PN} packages generated, will miss base function! Please check it!"
    fi

    # orgnanize README docs
    if ls ${README_PATH} >/dev/null 2>&1; then
        cp -r ${README_PATH} ${SSTATE_IN_DIR}/${SDK_PN}/
    else
        bbwarn "No README docs find in ${README_PATH}, Please Note it!"
    fi

    # organize all files as finial sdk
    cd ${SSTATE_IN_DIR}
    tar -zcf ${SSTATE_IN_DIR}/${SDK_PN}_${PV}.tar.gz ./${SDK_PN}
    rm -r ${SSTATE_IN_DIR}/${SDK_PN}
}

python do_generate_robotics_sdk_setscene() {
    sstate_setscene(d)
}
