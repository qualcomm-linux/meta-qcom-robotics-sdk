inherit ros_distro_${ROS_DISTRO}
inherit ros_component
inherit pkgconfig
inherit robotics-package

DESCRIPTION = "This ROS package builds gstreamer elements that can be loaded into a gstreamer pipeline. In this package, ROS is treated as a network-transport protocol for video, audio, and text. This package does not build ROS nodes."
LICENSE = "LGPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/LGPL-3.0-only;md5=bfccfe952269fff2b407dd11f2f3083b"

SRC_URI = "git://github.com/BrettRD/ros-gst-bridge.git;protocol=https;branch=develop"
SRCREV = "8b8f096726401b057cedd1ed4d3dffc929d619ca"

ROS_CN = "gst_bridge"
ROS_BPN = "gst_bridge"

S = "${UNPACKDIR}/${PN}-${PV}/${ROS_CN}"

ROS_BUILD_TYPE = "ament_cmake"
inherit ros_${ROS_BUILD_TYPE}

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
    ament-cmake-ros-native \
"

ROS_BUILD_DEPENDS = " \
    rclcpp \
    std-msgs \
    sensor-msgs \
    gstreamer1.0 \
    gstreamer1.0-plugins-base \
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
DEPENDS += "pkgconfig-native pkgconfig gstreamer1.0 glib-2.0"

do_configure:prepend() {
    export PKG_CONFIG_SYSROOT_DIR="${RECIPE_SYSROOT}"
    export PKG_CONFIG_PATH="${RECIPE_SYSROOT}${libdir}/pkgconfig:${RECIPE_SYSROOT}${datadir}/pkgconfig"
    export PKG_CONFIG_LIBDIR="${RECIPE_SYSROOT}${libdir}/pkgconfig:${RECIPE_SYSROOT}${datadir}/pkgconfig"
}

EXTRA_OECMAKE:append = " -DCMAKE_SYSROOT=${RECIPE_SYSROOT} -DPKG_CONFIG_SYSROOT_DIR=${RECIPE_SYSROOT}"

# EXTRA_OECMAKE += "-DSYSROOT_LIBDIR=${STAGING_LIBDIR}"
# EXTRA_OECMAKE += "-DGST_PLUGINS_QTI_OSS_INSTALL_LIBDIR=${libdir}"

GST_PLUGIN_INSTALL_DIR ?= "${libdir}/gstreamer-1.0"

do_install:append() {
    install -d -m 0755 ${D}${GST_PLUGIN_INSTALL_DIR}

    cd ${D}${GST_PLUGIN_INSTALL_DIR}
    ln -sf ../gst_bridge/librosgstbridge.so librosgstbridge.so
}

FILES:${PN} += "${libdir}"

SOLIBS = ".so*"
FILES_SOLIBSDEV = ""