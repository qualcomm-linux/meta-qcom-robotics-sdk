inherit ros_distro_${ROS_DISTRO}
inherit ros_component
inherit ros_insane_dev_so

DESCRIPTION      = "QRB AMR Library"
AUTHOR           = "Xiaowei Zhang <xiaowz@qti.qualcomm.com>"
ROS_AUTHOR       = "Xiaowei Zhang"
SECTION          = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=ad92c59628114dbd93a5031a4e684080"

ROS_CN = "qrb_amr_manager"
ROS_BPN = "qrb_amr_manager"

ROS_BUILD_DEPENDS = " \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
"

ROS_EXEC_DEPENDS = " \
"

ROS_EXPORT_DEPENDS = " \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

NON_ROS_EXEC_DEPENDS = " \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS} ${NON_ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_amr_service.git;protocol=https;branch=stable/1.0.4"
SRCREV = "5f7b966144252b604c3fb3f81472ab138b13c4a5"
S = "${UNPACKDIR}/${BP}/qrb_amr_manager"

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}

inherit robotics-package
