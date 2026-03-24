inherit ros_distro_${ROS_DISTRO}
inherit ros_component
inherit ros_insane_dev_so
inherit pkgconfig cmake

DESCRIPTION = "QRB Camera library"
AUTHOR = "Dan Wang <danwa@qti.qualcomm.com>"
ROS_AUTHOR = "Dan Wang"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

ROS_CN = "qrb_camera"
ROS_BPN = "qrb_camera"

ROS_BUILD_DEPENDS = " \
    camera-service \
    glib-2.0 \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
"

ROS_EXPORT_DEPENDS = " \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS += "pkgconfig-native"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS} ${ROS_TEST_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_camera.git;protocol=https;branch=stable/2.0.2;subpath=qrb_camera \
           file://0001-patch-update-for-qrb_camera.patch"
SRCREV = "5f88780ea9ef7c5df3d1c08899bdb89fbecbfab8"
S = "${UNPACKDIR}/qrb_camera"

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}

inherit robotics-package
