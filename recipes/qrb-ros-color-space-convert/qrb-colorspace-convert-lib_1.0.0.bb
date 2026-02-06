inherit ros_distro_${ROS_DISTRO}
inherit ros_component
inherit ros_insane_dev_so

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}
inherit robotics-package

DESCRIPTION = "The library to convert color space base on opengles"
AUTHOR = "Vito Wang <wantao@qti.qualcomm.com>"
ROS_AUTHOR = "Vito Wang"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=86fcc2294062130b497ba0ffff9f82fc"

ROS_CN = "qrb_colorspace_convert_lib"
ROS_BPN = "qrb_colorspace_convert_lib"

ROS_BUILD_DEPENDS = " \
    virtual/egl \
    virtual/libgles2 \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
"

ROS_EXPORT_DEPENDS = ""

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = ""

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/quic-qrb-ros/qrb_ros_color_space_convert.git;protocol=https;branch=stable/1.0.0-opengles"
SRCREV = "e8af86baa9e55f0c196164bd5f0a574e134a0965"
S = "${UNPACKDIR}/${PN}-${PV}/qrb_colorspace_convert_lib"
