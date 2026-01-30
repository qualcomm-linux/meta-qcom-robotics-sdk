# Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

# IMPORTANT: These packages contain Qualcomm proprietary pre-built binaries.
# Users receive only the binaries by default.
# Source code is available through authorized extra layers that require proper licensing.
# If you are not a developer within the Qualcomm organization, please add your packages to other packagegroups.

DESCRIPTION = "Qualcomm proprietary robotics packages containing pre-built binaries. These packages include Qualcomm-specific robotics optimizations, proprietary algorithms, and licensed intellectual property. Source code is available only through authorized extra layers that require proper licensing."
SUMMARY = "Qualcomm proprietary robotics pre-built binaries"
LICENSE = "BSD-3-Clause-Clear"

PACKAGE_ARCH = "${MACHINE_ARCH}"
inherit packagegroup
inherit rdepends-collector

# Qualcomm proprietary robotics binaries
QUALCOMM_ROBOTICS_PROPRIETARY = " \
"

RDEPENDS:${PN} = " \
    ${QUALCOMM_ROBOTICS_PROPRIETARY} \
"
