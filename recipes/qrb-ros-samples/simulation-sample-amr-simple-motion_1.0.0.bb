ROS_BUILD_TYPE = "ament_python"

ROS_CN = "simulation_sample_amr_simple_motion"
ROS_BPN = "simulation_sample_amr_simple_motion"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_samples.git;protocol=https;branch=stable-simulation_sample_amr_simple_motion/1.0.0"

SRCREV = "253360c77d6d004ee997211ee7b1bcaefb01c2ae"


ROS_BUILD_DEPENDS = " \
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
    python3 \
    python3-numpy \
    python3-pybind11 \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS} ${ROS_EXPORT_DEPENDS} ${ROS_TEST_DEPENDS}"
RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

require include/qrb-ros-samples.inc
