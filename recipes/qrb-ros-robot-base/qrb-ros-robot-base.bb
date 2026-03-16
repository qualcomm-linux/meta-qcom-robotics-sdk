inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION = "The QRB ROS robot base package"
LICENSE          = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a"

# ros build time dependency start
ROS_BUILD_DEPENDS = " \
    rclcpp \
    std-msgs \
    std-srvs \
    sensor-msgs \
    geometry-msgs \
    nav-msgs \
    nav2-msgs \
    tf2 \
    tf2-ros \
    rosidl-adapter \
    qrb-robot-base-manager \
    qrb-ros-robot-base-msgs \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
    ament-cmake-ros-native \
"

ROS_EXPORT_DEPENDS = ""
ROS_BUILDTOOL_EXPORT_DEPENDS = ""
# build time dependency end

# ros runtime dependency start
ROS_EXEC_DEPENDS = " \
    rclcpp \
    rclcpp-components \
    sensor-msgs \
    std-srvs \
    rosidl-adapter \
    xacro \
"
# ros runtime dependency end

ROS_TEST_DEPENDS = ""

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_robot_base.git;protocol=https;branch=main \
"
S = "${UNPACKDIR}/${BP}/qrb_ros_robot_base"

SRCREV = "3b71c18c5a64d6b1e147501e1d7677f4ae62baa3"

# define the build type : ament_cmake, ament_python, cmake etc...
ROS_BUILD_TYPE = "ament_cmake"
inherit ros_${ROS_BUILD_TYPE}

inherit robotics-package

RDEPENDS:${PN} += " \
    qrb-robot-base-manager \
    qrb-ros-robot-base-msgs \
"

EXTRA_OECMAKE += "${@oe.utils.conditional('DEBUG_BUILD','1',' -DENABLE_TEST=1 -DODOM_DATA_TEST=1','',d)}"

