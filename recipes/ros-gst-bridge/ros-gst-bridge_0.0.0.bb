inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION = "This ROS package builds gstreamer elements that can be loaded into a gstreamer pipeline. In this package, ROS is treated as a network-transport protocol for video, audio, and text. This package does not build ROS nodes."
LICENSE = "LGPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/LGPL-3.0-only;md5=bfccfe952269fff2b407dd11f2f3083b"

SRC_URI = "git://github.com/BrettRD/ros-gst-bridge.git;protocol=https;branch=develop"
SRCREV = "8b8f096726401b057cedd1ed4d3dffc929d619ca"

ROS_CN = "gst_bridge"
ROS_BPN = "gst_bridge"

S = "${UNPACKDIR}/${PN}-${PV}/${ROS_CN}"

inherit robotics-package

ROS_BUILD_TYPE = "ament_cmake"
inherit ros_${ROS_BUILD_TYPE}

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
    ament-cmake-ros-native \
"

ROS_BUILD_DEPENDS = " \
    rclcpp \
    gstreamer1.0-plugins-base \
    std-msgs \
    sensor-msgs \
    ros-gst-bridge-audio-msgs \
"

ROS_EXEC_DEPENDS = " \
    std-msgs \
    sensor-msgs \
    gstreamer1.0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    ros-gst-bridge-audio-msgs \
"

ROS_TEST_DEPENDS = " \
    ament-cmake-gtest \
    osrf-testing-tools-cpp \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "pkgconfig-native"

GST_PLUGIN_INSTALL_DIR ?= "${libdir}/gstreamer-1.0"

EXTRA_OECMAKE += "-DSYSROOT_LIBDIR=${STAGING_LIBDIR}"
EXTRA_OECMAKE += "-DGST_PLUGINS_QTI_OSS_INSTALL_LIBDIR=${libdir}"

do_install:append() {
    install -d -m 0755 ${D}${GST_PLUGIN_INSTALL_DIR}

    cd ${D}${GST_PLUGIN_INSTALL_DIR}
    ln -sf ../gst_bridge/librosgstbridge.so librosgstbridge.so
}

FILES:${PN} += "${libdir}"

SOLIBS = ".so*"
FILES_SOLIBSDEV = ""