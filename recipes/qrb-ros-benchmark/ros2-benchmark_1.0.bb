inherit ros_distro_${ROS_DISTRO}
inherit ros_component
inherit ros_insane_dev_so

DESCRIPTION = "Benchmarking framework for ROS 2 graphs"
SECTION = "devel"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://package.xml;beginline=28;endline=28;md5=82f0323c08605e5b6f343b05213cf7cc"

ROS_CN = "ros2_benchmark"
ROS_BPN = "ros2_benchmark"

ROS_BUILD_DEPENDS = " \
    rclcpp \
    rclcpp-action \
    rclcpp-components \
    ros2-benchmark-interfaces \
    rosbag2-compression-zstd \
    rosbag2-cpp \
    rosbag2-py \
    std-msgs \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
    ament-cmake-auto \
"

ROS_EXPORT_DEPENDS = ""

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    rosidl-default-runtime \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/ros2_benchmark.git;branch=stable/1.0.0;protocol=https;lfs=0 \
           file://0001-fix-rosbag2_compression-dependency-issue-in-ros2_benchmark.patch \
"
SRCREV = "c06e10927371f4933c740e87b42baecfe220705f"
S = "${UNPACKDIR}/${BPN}-${PV}/ros2_benchmark"

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}
