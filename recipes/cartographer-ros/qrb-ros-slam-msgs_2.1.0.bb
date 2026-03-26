inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION = "QRB AMR ROS Messages"
AUTHOR           = "Xiaohui Kuo <quic_xkuo@quicinc.com>"
ROS_AUTHOR       = "Xiaohui Kuo"
SECTION          = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=86fcc2294062130b497ba0ffff9f82fc"

ROS_CN = "qrb_ros_slam_msgs"
ROS_BPN = "qrb_ros_slam_msgs"

ROS_BUILD_DEPENDS = " \
    builtin-interfaces \
    geometry-msgs \
    std-msgs \
    rclcpp \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
    rosidl-default-generators-native \
"

ROS_EXPORT_DEPENDS = " \
    builtin-interfaces \
    geometry-msgs \
    std-msgs \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    builtin-interfaces \
    geometry-msgs \
    rosidl-default-runtime \
    std-msgs \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_interfaces.git;protocol=https;branch=main"
SRCREV = "0190003040d7ab66846b4b34ac326397aeded6e7"
S = "${UNPACKDIR}/${BP}/qrb_ros_slam_msgs"



ROS_BUILDTOOL_DEPENDS += " \
    rosidl-parser-native \
    rosidl-adapter-native \
    rosidl-typesupport-fastrtps-cpp-native \
    rosidl-typesupport-fastrtps-c-native \
    python3-numpy-native \
    python3-lark-parser-native \
"

# Without the target rosidl-typesupport-{c,cpp}, ament finds the native packages and then fails to link (error: incompatible
# target).
ROS_BUILD_DEPENDS += " \
    rosidl-typesupport-c \
    rosidl-typesupport-cpp \
    service-msgs \
"

ROS_BUILD_TYPE = "ament_cmake"
do_package_qa[noexec] = "1"
inherit ros_${ROS_BUILD_TYPE}

# for qirf
inherit robotics-package
