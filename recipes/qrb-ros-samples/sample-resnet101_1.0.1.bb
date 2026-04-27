ROS_BUILD_TYPE = "ament_python"

ROS_CN = "sample_resnet101"
ROS_BPN = "sample_resnet101"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_samples.git;protocol=https;branch=stable-sample_resnet101/1.0.1"

SRCREV = "08aba6c417703a8906b039fc7e33183eb19688c1"


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



