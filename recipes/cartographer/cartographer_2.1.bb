inherit ros_distro_${ROS_DISTRO}
inherit ros_superflore_generated pkgconfig

DESCRIPTION = "Cartographer is a system that provides real-time simultaneous localization and mapping (SLAM) in 2D and 3D across multiple platforms and sensor     configurations."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

ROS_BRANCH ?= "branch=ros2"
SRC_URI = "git://github.com/ros2/cartographer;${ROS_BRANCH};protocol=https \
           file://0001-Fix-compilation-errors-and-add-our-feature.patch \
"
SRCREV = "ddfd4414ef2907b6c46a195f1d4e380beedce05d"

S = "${UNPACKDIR}/${BP}"
PATCH_DIR = "${UNPACKDIR}/${BP}"
do_patch() {
    cd ${PATCH_DIR}
    git apply ${UNPACKDIR}/0001-Fix-compilation-errors-and-add-our-feature.patch
}

ROS_CN = "cartographer"
ROS_BPN = "cartographer"

ROS_BUILD_DEPENDS = " \
    abseil-cpp \
    boost \
    cairo \
    ceres-solver \
    gflags \
    git \
    glog \
    gtest \
    libeigen \
    lua \
    protobuf \
    python3-sphinx \
"

ROS_BUILDTOOL_DEPENDS = " \
    cmake-native \
"

ROS_EXPORT_DEPENDS = " \
    abseil-cpp \
    boost \
    cairo \
    ceres-solver \
    gflags \
    glog \
    libeigen \
    lua \
    protobuf \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    abseil-cpp \
    boost \
    cairo \
    ceres-solver \
    gflags \
    glog \
    libeigen \
    lua \
    protobuf \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"
DEPENDS += "gcc-runtime"
RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

ROS_BUILD_TYPE = "cmake"

# This is used only to generate documentation so it should
# be native and needs quite a lot of native python dependencies
ROS_BUILD_DEPENDS:remove = "${PYTHON_PN}-sphinx python-sphinx"

DEPENDS += " \
    protobuf-native \
"



# Doesn't need runtime dependency on ceres-solver
ROS_EXEC_DEPENDS:remove = "ceres-solver"

do_package_qa[noexec] = "1"

inherit ros_${ROS_BUILD_TYPE} robotics-package

