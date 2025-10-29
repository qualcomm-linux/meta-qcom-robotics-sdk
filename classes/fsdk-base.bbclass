# Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

PACKAGES = "${PN}"
FILES:${PN} = "/${SDK_PN}/"
DEPENDS:remove += "${BASEDEPENDS}"

# We only need the packaging tasks - disable the rest
do_configure[noexec] = "1"
do_compile[noexec] = "1"
do_populate_lic[noexec] = "1"
do_package_qa[noexec] = "1"
do_generate_robotics_sdk[nostamp] = "1"
INSANE_SKIP:${PN} += "already-stripped"
ALLOW_EMPTY:${PN} = "1"

#  Set ROBOTICS_ARCH according PACKAGE_ARCH, sepcific arm64 of aarch64
python __anonymous (){
    previous_arch = d.getVar('SOC_ARCH')
    if d.getVar('IMAGE_PKGTYPE') == "deb":
        if previous_arch == "aarch64":
            d.setVar("ROBOTICS_ARCH","arm64")
    else:
        d.setVar("ROBOTICS_ARCH",previous_arch)
}
