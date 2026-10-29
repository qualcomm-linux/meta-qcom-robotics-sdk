# Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

require recipes-products/images/qcom-multimedia-image.bb

inherit psdk-image
inherit rootfs-symlink

DESCRIPTION = "Robotics image built on top of the Qualcomm multimedia image (qcom-multimedia-image.bb), \
extending it with open-source robotics capabilities. Adds ROS2 framework, robotics applications, \
development tools, and robotics-specific packages. All components are fully open-source with \
no proprietary dependencies."

SUMMARY = "Open-source robotics image with ROS2 support"

LICENSE = "BSD-3-Clause-Clear"

CORE_IMAGE_BASE_INSTALL += "            \
    packagegroup-qcom-ros2              \
    packagegroup-robotics-opensource    \
    qirp-sdk                            \
"

ROOTFS_SYMLINK_PAIRS = "\
    ${@bb.utils.contains('DISTRO_FEATURES', 'sota', \
        '/usr/ros:/var/rootdirs/opt/ros', \
        '/usr/ros:/opt/ros', d)} \
"
