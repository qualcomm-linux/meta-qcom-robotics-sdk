inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION      = "QRB AMR ROS node"
AUTHOR           = "Xiaowei Zhang <quic_xiaowz@quicinc.com>"
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

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_amr_service.git;protocol=https;branch=release/1.0.4"
SRCREV = "3bae5512c84e977c708c22e89fb8fb6b9c46929c"
S         =  "${UNPACKDIR}/${BP}/qrb_ros_amr/"

ROS_BUILD_TYPE = "ament_cmake"
do_package_qa[noexec] = "1"
inherit ros_${ROS_BUILD_TYPE}

# for qirf
inherit robotics-package
