inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION = "QRB Navigation ROS Messages"
AUTHOR           = "Xiaowei Zhang <xiaowz@qti.qualcomm.com>"
ROS_AUTHOR       = "Xiaowei Zhang"
SECTION          = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=86fcc2294062130b497ba0ffff9f82fc"

ROS_CN = "qrb_ros_navigation_msgs"
ROS_BPN = "qrb_ros_navigation_msgs"

ROS_BUILD_DEPENDS = " \
    rclcpp \
    std-msgs \
    nav-msgs \
    rclcpp-components \
    geometry-msgs \
    action-msgs \
    rosidl-default-generators-native \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
"

ROS_EXEC_DEPENDS = " \
    rclcpp \
    std-msgs \
    nav-msgs \
    rclcpp-components \
    geometry-msgs \
    action-msgs \
"

ROS_EXPORT_DEPENDS = " \
    rclcpp \
    std-msgs \
    nav-msgs \
    rclcpp-components \
    geometry-msgs \
    action-msgs \
    rosidl-default-generators-native \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_interfaces.git;protocol=https;branch=stable/0.2.0"
SRCREV = "58afc211200aee777d16ce9b9e916f645de44190"
S = "${UNPACKDIR}/${BP}/qrb_ros_navigation_msgs"

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}

inherit robotics-package
