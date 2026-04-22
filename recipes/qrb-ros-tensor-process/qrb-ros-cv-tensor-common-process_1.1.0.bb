inherit ros_distro_${ROS_DISTRO}
inherit ros_component

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}
inherit robotics-package

SRC_URI  = "git://github.com/qualcomm-qrb-ros/qrb_ros_tensor_process.git;protocol=https;branch=stable/1.1.0"
SRCREV   = "6e5d64cda46e38a0b9536c1fe059b29ed97bd8b1"
S = "${UNPACKDIR}/${BPN}-${PV}/cv_tensor_process/cv_tensor_common_process"

DESCRIPTION = "QRB ROS CV tensor common process node"
AUTHOR = "Xiao Li <xiaolee@qti.qualcomm.com>"
ROS_AUTHOR = "Xiao Li"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=65b8cd575e75211d9d4ca8603167da1c"

ROS_CN = "qrb_ros_cv_tensor_common_process"
ROS_BPN = "qrb_ros_cv_tensor_common_process"

ROS_BUILD_DEPENDS = " \
    ament-index-cpp \
    cv-bridge \
    rclcpp \
    rclcpp-components \
    std-msgs \
    sensor-msgs \
    qrb-ros-tensor-list-msgs \
    qrb-ros-transport-image-type \
    lib-mem-dmabuf \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
    ament-cmake-ros-native \
"

ROS_EXEC_DEPENDS = " \
    rclcpp \
    sensor-msgs \
    qrb-ros-tensor-list-msgs \
    qrb-ros-transport-image-type \
    lib-mem-dmabuf \
    cv-bridge \
    rclcpp-components \
"

ROS_EXPORT_DEPENDS = " \
    rclcpp \
    ament-index-cpp \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = " \
"

ROS_TEST_DEPENDS = " \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS} ${ROS_TEST_DEPENDS}"


RDEPENDS:${PN} = "${ROS_EXEC_DEPENDS}"
