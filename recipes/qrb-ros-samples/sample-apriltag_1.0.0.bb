ROS_BUILD_TYPE = "ament_cmake"

ROS_CN = "sample_apriltag"
ROS_BPN = "sample_apriltag"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_samples.git;protocol=https;branch=stable-sample_apriltag/1.0.0"
SRCREV = "8437e7458d8c50a49a2f12627a5c3c4f7d0bb52a"

ROS_BUILD_DEPENDS = " \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
"

ROS_EXPORT_DEPENDS = " \
"

ROS_EXEC_DEPENDS = " \
    image-proc \
    rclcpp-components \
    qrb-ros-camera \
    qrb-ros-colorspace-convert \
    apriltag-ros \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS} ${ROS_EXPORT_DEPENDS} ${ROS_TEST_DEPENDS}"
RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

require include/qrb-ros-samples.inc
