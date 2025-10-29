# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
SDK_NAME = "qirp"

pkg_dest ?= "/opt/qcom/${SDK_NAME}-sdk"
pkg_dest = " "

do_move_opt() {
    if [ "${pkg_dest}" == "/" or "${pkg_dest}" == " " ]; then
        bbnote "pkg_dest set to root , did not need copy"
    else
        bbnote "copy file from / to ${pkg_dest}"
        install -d ${D}/${pkg_dest}
        for item in ${D}/*; do
            if [ -d "$item" ] && [ "$item" != "${D}/opt" ]; then
                cp -r "$item" "${D}/${pkg_dest}"
            fi
        done
    fi
}

do_install[postfuncs] += "do_move_opt"

AUTO_LIBNAME_PKGS = ""

FILES:${PN} += " \
    ${pkg_dest}${bindir} \
    ${pkg_dest}${sbindir} \
    ${pkg_dest}${base_bindir} \
    ${pkg_dest}${base_sbindir} \
    ${pkg_dest}${libexecdir} \
    ${pkg_dest}${sysconfdir} \
"

PROVIDES += "${PN}"
do_copy_source() {
    if [ ! -d "${SAMPLE_SOURCE}/" ]; then
        mkdir -p "${SAMPLE_SOURCE}/"
    fi

    if [ -d "${S}" ]; then
        cp -rf ${S} ${SAMPLE_SOURCE}/${PN}
    fi
}
addtask copy_source before do_configure after do_patch

RPROVIDES:${PN} += "${PN}"

FILES:${PN}-dev = "${pkg_dest}${includedir} ${pkg_dest}${base_libdir}/lib*${SOLIBSDEV} \
                ${pkg_dest}${libdir}/lib*${SOLIBSDEV} ${pkg_dest}${libdir}/*.la \
                ${pkg_dest}${libdir}/*.o ${pkg_dest}${libdir}/pkgconfig ${pkg_dest}${datadir}/pkgconfig \
                ${pkg_dest}${datadir}/aclocal ${pkg_dest}${base_libdir}/*.o \
                ${pkg_dest}${libdir}/${BPN}/*.la ${pkg_dest}${base_libdir}/*.la \
                ${pkg_dest}${libdir}/cmake ${pkg_dest}${datadir}/cmake"
SECTION:${PN}-dev = "devel"
PROVIDES += "${PN}-dev"
RPROVIDES:${PN}-dev += "${PN}-dev"
RDEPENDS:${PN}-dev = "${PN} (= ${EXTENDPKGV})"

FILES:${PN}-staticdev = "${pkg_dest}${libdir}/*.a ${pkg_dest}${base_libdir}/*.a ${pkg_dest}${libdir}/${BPN}/*.a"
SECTION:${PN}-staticdev = "devel"
PROVIDES += "${PN}-staticdev"
RPROVIDES:${PN}-staticdev += "${PN}-staticdev"
RDEPENDS:${PN}-staticdev = "${PN}-dev (= ${EXTENDPKGV})"

FILES:${PN}-dbg = "${pkg_dest}${libdir}/debug"

ROS_EXEC_DEPENDS ?= " "
ROS_BUILD_DEPENDS ?= " "

RDEPENDS:${PN}:remove = "${@remove_rdepends(d)}"

INSANE_SKIP:${PN} += "installed-vs-shipped"
INSANE_SKIP:${PN} += "${@skip_ros_dev_so_check(d)}"

INSANE_SKIP:${PN} += "already-stripped"
INSANE_SKIP:${PN} += "installed-vs-shipped"
INSANE_SKIP:${PN} += "${@skip_ros_dev_so_check(d)}"

# while enable ubuntu target compilation ,stop the shlibs
PACKAGEFUNCS:remove = "${@packages_funcs(d)}"

def skip_ros_dev_so_check(d):
    # Your code here
    ros_exec_depends = d.getVar("ROS_EXEC_DEPENDS") or ""
    ros_build_depends = d.getVar("ROS_BUILD_DEPENDS") or ""
    if len(ros_exec_depends.strip()) != 0 or len(ros_build_depends.strip()) != 0:
        return "dev-so"
    return ""
def packages_funcs(d):
    # Your code here
    ros_exec_depends = d.getVar("ROS_EXEC_DEPENDS") or ""
    ros_build_depends = d.getVar("ROS_BUILD_DEPENDS") or ""
    ubuntu_version = d.getVar("UBUNTU_VERSION") or ""
    if len(ros_exec_depends.strip()) != 0 or len(ros_build_depends.strip()) != 0:
        if len(ubuntu_version.strip()) != 0:
            return "package_do_shlibs"
    return ""
def remove_rdepends(d):
    ros_exec_depends = d.getVar("ROS_EXEC_DEPENDS") or ""
    ros_build_depends = d.getVar("ROS_BUILD_DEPENDS") or ""
    ubuntu_version = d.getVar("UBUNTU_VERSION") or ""
    # if set ROS_EXEC_DEPENDS in Ubuntu build , return the ros_exec_deepends
    if len(ros_exec_depends.strip()) != 0 or len(ros_build_depends.strip()) != 0:
        if len(ubuntu_version.strip()) != 0:
            return ros_exec_depends
    return ""
def get_runtime_depends(PN,d):
    runtime_depends = d.getVar('RDEPENDS:{}'.format(PN), True)
    if runtime_depends :
        return runtime_depends
    return " "


# define the ${PN} package to replace ${PN}
# package all the file to ${PN}
# add provide for ${PN} , keep ${PN} as provider too
# add Rprovider ${PN} , keep ${PN} as provider too

python __anonymous(){
    package_name = d.getVar("PN")
    target_package_name = ""
    ros_exec_depends = d.getVar("ROS_EXEC_DEPENDS") or ""
    ros_build_depends = d.getVar("ROS_BUILD_DEPENDS") or ""
    if len(ros_exec_depends.strip()) == 0 and len(ros_build_depends.strip()) == 0:
        target_package_name = "{}-dev {}-staticdev {} {}-dbg".format(package_name,package_name,package_name,package_name)
    else :
        target_package_name = "{} {}-dbg".format(package_name,package_name)
    d.setVar("PACKAGES",target_package_name)

    soc_arch = d.getVar("SOC_ARCH")
    d.setVar('PACKAGE_ARCH',soc_arch)

    ubuntu_version = d.getVar("UBUNTU_VERSION") or ""
    if len(ros_exec_depends.strip()) != 0 or len(ros_build_depends.strip()) != 0:
        if len(ubuntu_version.strip()) != 0:
            d.setVarFlag('do_package_qa', 'noexec', '1')
}
