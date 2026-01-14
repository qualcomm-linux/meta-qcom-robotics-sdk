# Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

require recipes-products/images/qcom-multimedia-proprietary-image.bb
require qcom-robotics-image.bb

inherit psdk-image

DESCRIPTION = "Robotics image extending the open-source robotics image with \
Qualcomm multimedia proprietary features, Qualcomm-optimized robotics components, \
and third-party features that depend on Qualcomm proprietary technology. \
Adds: \
1) Multimedia proprietary components from qcom-multimedia-proprietary-image, \
2) Open-source robotics packages with Qualcomm proprietary dependencies, \
3) Qualcomm proprietary robotics binaries, \
4) Third-party features requiring Qualcomm private components. \
"

SUMMARY = "Robotics image with Qualcomm proprietary optimizations"

LICENSE = "BSD-3-Clause-Clear"

CORE_IMAGE_BASE_INSTALL += " \
    packagegroup-robotics-oss-with-prop-deps \
    packagegroup-robotics-proprietary \
"
