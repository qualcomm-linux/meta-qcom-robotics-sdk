inherit ros_distro_${ROS_DISTRO}
inherit ros_component
inherit ros_insane_dev_so

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}
inherit robotics-package

DESCRIPTION = "Type Adaption with Linux dma-buf"
AUTHOR = "Peng Wang <penwang@qti.qualcomm.com>"
ROS_AUTHOR = "Peng Wang"
SECTION = "devel"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86fcc2294062130b497ba0ffff9f82fc"

ROS_CN = "dmabuf_transport"
ROS_BPN = "dmabuf_transport"

ROS_BUILD_DEPENDS = " \
    rclcpp \
    sensor-msgs \
    lib-mem-dmabuf \
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
    lib-mem-dmabuf \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS} ${ROS_TEST_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/dmabuf_transport.git;protocol=https;branch=main"
SRCREV = "b6921ef49cac9c51894b3055b298558e82389d32"
