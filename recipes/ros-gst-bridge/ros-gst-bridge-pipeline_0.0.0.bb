inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION = "This package provides a ROS node that hosts a gstreamer pipeline inside a ROS composable node. This is similar to the gscam2 package, but here we use the gst-bridge package for shared-memory IO, allowing this package to focus on supporting features we attach to the pipeline itself."
LICENSE = "LGPL-3.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/LGPL-3.0-only;md5=bfccfe952269fff2b407dd11f2f3083b"

SRC_URI = "git://github.com/BrettRD/ros-gst-bridge.git;protocol=https;branch=develop"
SRCREV = "8b8f096726401b057cedd1ed4d3dffc929d619ca"

ROS_CN = "gst_pipeline"
ROS_BPN = "gst_pipeline"

S = "${UNPACKDIR}/${PN}-${PV}/${ROS_CN}"

inherit robotics-package

ROS_BUILD_TYPE = "ament_cmake"
inherit ros_${ROS_BUILD_TYPE}

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
    ament-cmake-ros-native \
"

ROS_BUILD_DEPENDS = " \
    gstreamer1.0-plugins-base \
    rclcpp \
    rclcpp-components \
    std-msgs \
    sensor-msgs \
    ros-gst-bridge-audio-msgs \
    ros-gst-bridge-msgs \
    ros-gst-bridge \
    image-transport \
    cv-bridge \
    class-loader \
    std-srvs \
"

ROS_EXEC_DEPENDS = " \
    rclcpp-components \
    image-transport \
    cv-bridge \
    std-msgs \
    sensor-msgs \
    ros-gst-bridge-audio-msgs \
    ros-gst-bridge-msgs \
    ros-gst-bridge \
    gstreamer1.0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    class-loader \
    std-srvs \
"

ROS_TEST_DEPENDS = " \
    ament-cmake-gtest \
    osrf-testing-tools-cpp \
    rclcpp \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "pkgconfig-native"

EXTRA_OECMAKE += "-DSYSROOT_LIBDIR=${STAGING_LIBDIR}"
EXTRA_OECMAKE += "-DGST_PLUGINS_QTI_OSS_INSTALL_LIBDIR=${libdir}"
# Disable format-security for error: "format not a string literal and no format arguments"
EXTRA_OECMAKE:append = " -DCMAKE_CXX_FLAGS='-Wno-error=format-security'"
# Skip build of tests for QA issues
INSANE_SKIP:${PN} += "buildpaths"

FILES:${PN} += "${libdir}"

SOLIBS = ".so*"
FILES_SOLIBSDEV = ""