SUMMARY = "QRB ROS Samples (Python ROS 2 packages)"
DESCRIPTION = "Sample ROS 2 Python nodes for Qualcomm Robotics SDK"
HOMEPAGE = "https://github.com/qualcomm-qrb-ros/qrb_ros_samples"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_samples.git;protocol=https;branch=main"
SRCREV = "e4100d52ef9e13c8ce20b6288651c8bcc294ae29"

inherit ros_${ROS_BUILD_TYPE}
inherit ros_distro_${ROS_DISTRO} pkgconfig
inherit ros_component robotics-package
