LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a"

ROS_BUILD_TYPE = "ament_python"

inherit ros_${ROS_BUILD_TYPE}
inherit ros_distro_${ROS_DISTRO} pkgconfig
inherit ros_component robotics-package


ROS_CN = "simulation_remote_assistant"
ROS_BPN = "simulation_remote_assistant"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_samples.git;protocol=https;branch=stable-simulation_remote_assistant/1.0.0"
SRCREV = "b7fd87ee8ccf773a05647cde96a6ea22217f8ef5"

ROS_BUILD_DEPENDS = " \
   python3-setuptools-native \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-python \
    ament-index-python \
"

ROS_EXPORT_DEPENDS = " \
"

ROS_EXEC_DEPENDS = " \
    std-msgs \
    sensor-msgs \
    geometry-msgs \
    vision-msgs \
    qrb-ros-slam-msgs \
    nav-msgs \
    python3 \
    python3-pyyaml \
    python3-numpy \
    python3-pybind11 \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS} ${ROS_EXPORT_DEPENDS} ${ROS_TEST_DEPENDS}"
RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

