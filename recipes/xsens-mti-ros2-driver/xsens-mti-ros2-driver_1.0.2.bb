inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION = "ROS 2.0 driver for Xsens MTi IMU sensors"
HOMEPAGE = "https://github.com/xsenssupport/Xsens_MTi_ROS_Driver_and_Ntrip_Client"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${S}/LICENSE.txt;md5=eafe7ba0ab1f08e996b4dcf42d0b8141"

ROS_CN = "xsens_mti_ros2_driver"
ROS_BPN = "xsens_mti_ros2_driver"

ROS_BUILD_DEPENDS = " \
    rclcpp \
    tf2 \
    tf2-ros \
    std-msgs \
    geometry-msgs \
    sensor-msgs \
    nav-msgs \
    nmea-msgs \
    mavros-msgs \
    rosidl-default-generators-native \
    rosidl-default-runtime \
    libeigen \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
"

ROS_EXPORT_DEPENDS = " \
    rclcpp \
    tf2 \
    tf2-ros \
    std-msgs \
    geometry-msgs \
    sensor-msgs \
    nav-msgs \
    nmea-msgs \
    mavros-msgs \
    libeigen \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    rclcpp \
    tf2 \
    tf2-ros \
    std-msgs \
    geometry-msgs \
    sensor-msgs \
    nav-msgs \
    nmea-msgs \
    mavros-msgs \
    rosidl-default-runtime \
"

# Currently informational only -- see http://www.ros.org/reps/rep-0149.html#dependency-tags.
ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
# Bitbake doesn't support the "export" concept, so build them as if we needed them to build this package (even though we actually
# don't) so that they're guaranteed to have been staged should this package appear in another's DEPENDS.
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

ROS_BRANCH ?= "branch=ros2"
SRC_URI = "git://github.com/xsenssupport/Xsens_MTi_ROS_Driver_and_Ntrip_Client.git;${ROS_BRANCH};protocol=https"
SRCREV = "d6b87ecf63297b814a4084b95a7b5daf0713be62"

# The upstream repository ships two ROS 2 packages under src/: xsens_mti_ros2_driver
# and ntrip. We only want to build xsens_mti_ros2_driver, so point S at that
# subdirectory and let the ament_cmake class build it directly.
S = "${UNPACKDIR}/${BP}/src/xsens_mti_ros2_driver"

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}
