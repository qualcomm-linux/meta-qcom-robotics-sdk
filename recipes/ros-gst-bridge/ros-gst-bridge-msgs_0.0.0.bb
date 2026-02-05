inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION = "gst_msgs: subpackage of ros-gst-bridge."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "git://github.com/BrettRD/ros-gst-bridge.git;protocol=https;branch=develop"
SRCREV = "8b8f096726401b057cedd1ed4d3dffc929d619ca"

ROS_CN = "gst_msgs"
ROS_BPN = "gst_msgs"

S = "${UNPACKDIR}/${PN}-${PV}/${ROS_CN}"

inherit robotics-package

ROS_BUILD_TYPE = "ament_cmake"
inherit ros_${ROS_BUILD_TYPE}

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
    ament-cmake-ros-native \
    rosidl-default-generators-native \
"

ROS_BUILD_DEPENDS = " \
    rosidl-default-generators \
    sensor-msgs \
"

ROS_EXEC_DEPENDS = " \
    rosidl-default-runtime \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"

EXTRA_OECMAKE += "-DSYSROOT_LIBDIR=${STAGING_LIBDIR}"
EXTRA_OECMAKE += "-DGST_PLUGINS_QTI_OSS_INSTALL_LIBDIR=${libdir}"

FILES:${PN} += "${libdir}"

SOLIBS = ".so*"
FILES_SOLIBSDEV = ""