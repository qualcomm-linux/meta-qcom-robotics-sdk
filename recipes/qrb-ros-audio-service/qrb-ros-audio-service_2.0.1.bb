inherit ros_distro_${ROS_DISTRO}
inherit ros_component
inherit ros_insane_dev_so
inherit pkgconfig

DESCRIPTION = "QRB ROS Audio Service"
AUTHOR = "Yuchao Pan <yuchpan@qti.qualcomm.com>"
ROS_AUTHOR = "Yuchao Pan"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=68c28a8a26024c85c589d0de638520b6"

ROS_CN = "qrb_ros_audio_service"
ROS_BPN = "qrb_ros_audio_service"

ROS_BUILD_DEPENDS = " \
    rclcpp \
    rclcpp-components \
    rclcpp-action \
    qrb-audio-service-lib \
    qrb-ros-audio-service-msgs \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
    rosidl-default-generators-native \
"

ROS_EXPORT_DEPENDS = ""

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    rclcpp \
    qrb-audio-service-lib \
    qrb-ros-audio-service-msgs \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/quic-qrb-ros/qrb_ros_audio_service.git;protocol=https;branch=stable/2.0.1"
SRCREV = "32c4bb2d38954f2671a1eba8cf85b01f437f2943"
S = "${UNPACKDIR}/${BP}/qrb_ros_audio_service"
PV = "2.0.1"

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}

inherit robotics-package
