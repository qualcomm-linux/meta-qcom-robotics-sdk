inherit ros_distro_${ROS_DISTRO}
inherit ros_component
inherit ros_insane_dev_so

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}
inherit robotics-package

DESCRIPTION = "Test for ROS type adaption with Linux DMA buffer"
AUTHOR = "Peng Wang <penwang@qti.qualcomm.com>"
ROS_AUTHOR = "Peng Wang"
SECTION = "devel"
LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86fcc2294062130b497ba0ffff9f82fc"

ROS_CN = "dmabuf_transport_test"
ROS_BPN = "dmabuf_transport_test"

ROS_BUILD_DEPENDS = " \
    rclcpp \
    rclcpp-components \
    sensor-msgs \
    dmabuf-transport \
    pcl \
    pcl-conversions \
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
    rclcpp-components \
    sensor-msgs \
    pcl \
    pcl-conversions \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
    ament-cmake-lint-cmake \
    ament-cmake-uncrustify \
    ament-cmake-xmllint \
    ament-cmake-cppcheck-native \
    ament-cmake-flake8-native \
    ament-cmake-pep257-native \
    ament-uncrustify-native \
    ament-lint-cmake-native \
    ament-xmllint-native \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS} ${ROS_TEST_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/dmabuf_transport.git;protocol=https;branch=dmabuf_transport_test"
SRCREV = "b99aed729956575c6880057cea7ee99dbbf0f054"
