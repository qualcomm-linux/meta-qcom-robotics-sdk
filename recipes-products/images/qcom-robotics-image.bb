# Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

include recipes-products/images/qcom-multimedia-image.bb
inherit core-image

SUMMARY = "multimedia image with ROS core"

LICENSE = "BSD-3-Clause-Clear"

CORE_IMAGE_BASE_INSTALL += " \
    ros-core \
    demo-nodes-cpp \
"

