inherit ros_distro_${ROS_DISTRO}
inherit ros_component
inherit ros_insane_dev_so

DESCRIPTION = "Interfaces for benchmark testing"
SECTION = "devel"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://package.xml;beginline=28;endline=28;md5=82f0323c08605e5b6f343b05213cf7cc"

ROS_CN = "ros2_benchmark"
ROS_BPN = "ros2_benchmark_interfaces"

ROS_BUILD_DEPENDS = " \
    rosidl-default-generators \
    std-msgs \
    sensor-msgs \
    vision-msgs \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
    ament-cmake-ros-native \
    rosidl-default-generators-native \
"

ROS_EXPORT_DEPENDS = "rosidl-default-runtime"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
   std-msgs \
   sensor-msgs \
   vision-msgs \
   rosidl-default-runtime \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/ros2_benchmark;branch=stable/1.0.0;protocol=https;lfs=0"
SRCREV = "c06e10927371f4933c740e87b42baecfe220705f"
S = "${UNPACKDIR}/${BPN}-${PV}/ros2_benchmark_interfaces"

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}

