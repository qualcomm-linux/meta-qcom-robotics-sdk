inherit ros_distro_${ROS_DISTRO}
inherit ros_superflore_generated

DESCRIPTION = "ROS messages for the cartographer_ros package."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://package.xml;beginline=62;endline=62;md5=3dce4ba60d7e51ec64f3c3dc18672dd3"

ROS_CN = "cartographer_ros"
ROS_BPN = "cartographer_ros_msgs"

ROS_BUILD_DEPENDS = " \
    builtin-interfaces \
    geometry-msgs \
    std-msgs \
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

ROS_BRANCH ?= "branch=ros2"
SRC_URI = "git://github.com/ros2/cartographer_ros;${ROS_BRANCH};protocol=https \
           file://0001-Add-qrb-slam-feature.patch \
"
SRCREV = "1bbf9af3d250ba7d17f9b2340e7fe01ac22cf7a7"
S = "${UNPACKDIR}/${BP}/cartographer_ros_msgs"
B = "${UNPACKDIR}/${BP}/cartographer_ros_msgs"

PATCH_DIR = "${UNPACKDIR}/${BP}"
do_patch() {
    cd ${PATCH_DIR}
    git apply ${UNPACKDIR}/0001-Add-qrb-slam-feature.patch
}

ROS_BUILDTOOL_DEPENDS += " \
    rosidl-parser-native \
    rosidl-adapter-native \
    rosidl-typesupport-fastrtps-cpp-native \
    rosidl-typesupport-fastrtps-c-native \
    python3-numpy-native \
    python3-lark-parser-native \
"

ROS_BUILD_DEPENDS += " \
    rosidl-typesupport-c \
    rosidl-typesupport-cpp \
    service-msgs \
"

ROS_BUILD_TYPE = "ament_cmake"

do_package_qa[noexec] = "1"

inherit ros_${ROS_BUILD_TYPE} robotics-package

