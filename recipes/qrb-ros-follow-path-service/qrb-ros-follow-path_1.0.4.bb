inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION = "QRB Follow Path ROS node"
AUTHOR           = "Xiaowei Zhang <xiaowz@qti.qualcomm.com>"
ROS_AUTHOR       = "Xiaowei Zhang"
SECTION          = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=86fcc2294062130b497ba0ffff9f82fc"

ROS_CN = "qrb_ros_follow_path"
ROS_BPN = "qrb_ros_follow_path"

ROS_BUILD_DEPENDS = " \
    rclcpp \
    std-msgs \
    rclcpp-components \
    nav-msgs \
    nav2-msgs \
    sensor-msgs \
    geometry-msgs \
    rclcpp-action \
    tf2 \
    nav-2d-msgs \
    tf2-ros \
    tf2-geometry-msgs \
    rclcpp-lifecycle \
    qrb-ros-amr-msgs \
    qrb-ros-navigation-msgs \
    qrb-follow-path-manager \
    qrb-ros-robot-base-msgs \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
"

ROS_EXEC_DEPENDS = " \
    rclcpp \
    std-msgs \
    rclcpp-components \
    nav-msgs \
    nav2-msgs \
    sensor-msgs \
    geometry-msgs \
    rclcpp-action \
    tf2 \
    nav-2d-msgs \
    tf2-ros \
    tf2-geometry-msgs \
    rclcpp-lifecycle \
"

ROS_EXPORT_DEPENDS = " \
    rclcpp \
    std-msgs \
    rclcpp-components \
    nav-msgs \
    nav2-msgs \
    sensor-msgs \
    geometry-msgs \
    rclcpp-action \
    tf2 \
    nav-2d-msgs \
    tf2-ros \
    tf2-geometry-msgs \
    rclcpp-lifecycle \
"

NON_ROS_EXEC_DEPENDS = " \
    qrb-ros-amr-msgs \
    qrb-ros-navigation-msgs \
    qrb-follow-path-manager \
    qrb-ros-robot-base-msgs \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS} ${NON_ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_follow_path_service.git;protocol=https;branch=stable/1.0.4"
SRCREV = "f62e9f9a18a330240a4e2e5c9776f75861c9473b"
S         =  "${UNPACKDIR}/${BP}/qrb_ros_follow_path/"

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}

inherit robotics-package
