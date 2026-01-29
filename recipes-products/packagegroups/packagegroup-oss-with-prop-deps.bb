# Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

# IMPORTANT: All packages in this group have OPEN-SOURCE CODE
# but require QUALCOMM PROPRIETARY dependencies at runtime.
# Users must have proper licenses for the proprietary components.

DESCRIPTION = "Open-source packages that require Qualcomm proprietary components at runtime. The source code of these packages is open-source, but they depend on Qualcomm proprietary libraries, drivers, or firmware. Proper licenses are required for the proprietary dependencies."
SUMMARY = "Open-source packages with Qualcomm proprietary dependencies"
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
    sample-hrnet-pose-estimation \
"

# If you do not work within the above two organizations and are preparing to merge your code into the Qualcomm Linux Intelligence Robotics Image, 
# please place it in the following variable.
EXTERNAL_OPENSOURCE = "   \
"

RDEPENDS:${PN} = "${QUALCOMM_QRB_ROS} ${QRB_ROS_SAMPLE} ${EXTERNAL_OPENSOURCE}"
