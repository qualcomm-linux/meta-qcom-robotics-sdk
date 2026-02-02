inherit ros_distro_${ROS_DISTRO}
inherit ros_component
inherit ros_insane_dev_so

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}
inherit robotics-package

DESCRIPTION = "Type Adaption for IMU on Qualcomm robotics platforms"
AUTHOR = "Peng Wang <penwang@qti.qualcomm.com>"
ROS_AUTHOR = "Peng Wang"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=86fcc2294062130b497ba0ffff9f82fc"

ROS_CN = "qrb_ros_transport_imu_type"
ROS_BPN = "qrb_ros_transport_imu_type"

ROS_BUILD_DEPENDS = " \
    rclcpp \
    sensor-msgs \
    qrb-sensor-client \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
"

ROS_EXPORT_DEPENDS = " \
    rclcpp \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    rclcpp \
    sensor-msgs \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
    rclcpp-components \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS} ${ROS_TEST_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_transport.git;protocol=https;branch=stable/1.3.0"
SRCREV = "72642db004e4cf58208c72733dd8da6d74339d58"
S = "${UNPACKDIR}/${PN}-${PV}/qrb_ros_transport_imu_type"
