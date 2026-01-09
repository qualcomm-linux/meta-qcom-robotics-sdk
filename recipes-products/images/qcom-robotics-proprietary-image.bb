# Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

include recipes-products/images/qcom-multimedia-proprietary-image.bb
inherit core-image

SUMMARY = "multimedia image with ros and qirp sdk"

LICENSE = "BSD-3-Clause-Clear"

CORE_IMAGE_BASE_INSTALL += " \
    packagegroup-qcom-ros2 \
    qirp-sdk \
"

CORE_IMAGE_BASE_INSTALL:append = " \
    packagegroup-qcom-robotics \
"
