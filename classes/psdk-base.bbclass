# Copyright (c) 2023-2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

PACKAGES = "${PN}"
FILES:${PN} = "/${SDK_PN}/*"
DEPENDS:remove = "${BASEDEPENDS}"
DEPENDS += "binutils-cross-aarch64"

# We only need the packaging tasks - disable the rest
do_configure[noexec] = "1"
do_compile[noexec] = "1"
do_populate_lic[noexec] = "1"
do_package_qa[noexec] = "1"
INSANE_SKIP:${PN} += "already-stripped"
ALLOW_EMPTY:${PN} = "1"
EXCLUDE_FROM_SHLIBS = "1"

