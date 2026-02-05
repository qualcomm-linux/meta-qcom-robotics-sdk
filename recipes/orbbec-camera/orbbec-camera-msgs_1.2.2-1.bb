inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION = "Orbbec camera messages definitions"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

ROS_CN = "orbbec_camera"
ROS_BPN = "orbbec_camera_msgs"

ROS_BUILD_DEPENDS = " \
    rosidl-default-generators-native \
    sensor-msgs \
    std-msgs \
    rosidl-default-runtime \
    rclcpp \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
"

ROS_EXEC_DEPENDS = " \
    sensor-msgs \
    std-msgs \
    rosidl-default-runtime \
    rclcpp \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

ROS_BRANCH ?= "branch=v2-main"
SRC_URI = "git://github.com/orbbec/OrbbecSDK_ROS2.git;${ROS_BRANCH};protocol=https;depth=1"
SRCREV = "5f231a8eb80d69f7c3672eec1eaf27bb04889785"
S = "${UNPACKDIR}/${BP}/orbbec_camera_msgs"

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE} robotics-package
