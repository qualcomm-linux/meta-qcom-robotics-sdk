inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION      = "QRB AMR ROS node"
AUTHOR           = "Xiaowei Zhang <xiaowz@qti.qualcomm.com>"
ROS_AUTHOR       = "Xiaowei Zhang"
SECTION          = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=ad92c59628114dbd93a5031a4e684080"

ROS_CN = "qrb_ros_amr"
ROS_BPN = "qrb_ros_amr"

ROS_BUILD_DEPENDS = " \
    rclcpp \
    std-msgs \
    rclcpp-components \
    nav-msgs \
    nav2-msgs \
    nav-2d-msgs \
    geometry-msgs \
    rclcpp-action \
    tf2 \
    tf2-ros \
    tf2-geometry-msgs \
    sensor-msgs \
    jsoncpp \
    qrb-ros-amr-msgs \
    qrb-ros-navigation-msgs \
    qrb-amr-manager \
    qrb-ros-robot-base-msgs \
    qrb-ros-slam-msgs \
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
    nav-2d-msgs \
    geometry-msgs \
    rclcpp-action \
    tf2 \
    tf2-ros \
    tf2-geometry-msgs \
    sensor-msgs \
"

ROS_EXPORT_DEPENDS = " \
    rclcpp \
    std-msgs \
    rclcpp-components \
    nav-msgs \
    nav2-msgs \
    nav-2d-msgs \
    geometry-msgs \
    rclcpp-action \
    tf2 \
    tf2-ros \
    tf2-geometry-msgs \
    sensor-msgs \
"

NON_ROS_EXEC_DEPENDS = " \
    jsoncpp \
    qrb-ros-amr-msgs \
    qrb-ros-navigation-msgs \
    qrb-amr-manager \
    qrb-ros-robot-base-msgs \
    qrb-ros-slam-msgs \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"


do_install:append() {
    rm -rf ${D}/usr/include/*
    install -d ${D}/usr/include/qrb_ros_amr/
    cp -r ${S}/include/*  ${D}/usr/include/qrb_ros_amr/
}


RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS} ${NON_ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_amr_service.git;protocol=https;branch=stable/1.0.4"
SRCREV = "5f7b966144252b604c3fb3f81472ab138b13c4a5"
S         =  "${UNPACKDIR}/${BP}/qrb_ros_amr/"

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}

inherit robotics-package
