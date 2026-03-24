inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION = "QRB Follow Path ROS node"
AUTHOR           = "Xiaowei Zhang <quic_xiaowz@quicinc.com>"
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

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_follow_path_service.git;protocol=https;branch=release/1.0.4"
SRCREV = "751081b3a04fb80101516e92a52c250177ad5f21"
S         =  "${UNPACKDIR}/${BP}/qrb_ros_follow_path/"

ROS_BUILD_TYPE = "ament_cmake"
do_package_qa[noexec] = "1"
inherit ros_${ROS_BUILD_TYPE}

# for qirf
inherit robotics-package
