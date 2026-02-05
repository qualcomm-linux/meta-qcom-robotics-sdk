# Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

# IMPORTANT: All packages in this group must have OPEN-SOURCE CODE
# and OPEN-SOURCE DEPENDENCIES only. No proprietary components are allowed.
# If a package has open-source code but depends on proprietary components,
# it should be placed in packagegroup-oss-with-prop-deps.bb instead.

DESCRIPTION = "Collection of open-source robotics packages from various communities. Includes Qualcomm open-source robotics projects, sample applications, and third-party robotics software. All packages are fully open-source with no proprietary dependencies."
SUMMARY = "Open-source robotics packages from the community"
LICENSE = "BSD-3-Clause-Clear"

PACKAGE_ARCH = "${MACHINE_ARCH}"
inherit packagegroup

# If it is robotics feature, Please place all of them under this variable.
# About qualcomm-qrb-ros information, Please refer to https://github.com/qualcomm-qrb-ros.
QUALCOMM_QRB_ROS = " \
"

# If it is qrb ros sample, Please place all of them under this variable.
# About qrb ros sample introduction, Please refer to https://github.com/qualcomm-qrb-ros/qrb_ros_samples.
QRB_ROS_SAMPLE = " \
    simulation-sample-amr-simple-motion \
"

# If you do not work within the above two organizations and are preparing to merge your code into the Qualcomm Linux Intelligence Robotics Image, 
# please place it in the following variable.
EXTERNAL_OPENSOURCE = " \
    ${ROS_GST_BRIDGE} \
    rplidar-ros2 \
"

ROS_GST_BRIDGE = " \
    ros-gst-bridge-audio-msgs \
    ros-gst-bridge-msgs \
    ros-gst-bridge \
    ros-gst-bridge-pipeline \
    ros-gst-bridge-pipeline-plugins \
"

RDEPENDS:${PN} = "${QUALCOMM_QRB_ROS} ${QRB_ROS_SAMPLE} ${EXTERNAL_OPENSOURCE}"
