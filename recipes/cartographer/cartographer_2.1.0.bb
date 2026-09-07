inherit ros_distro_${ROS_DISTRO}
inherit ros_superflore_generated pkgconfig

DESCRIPTION = "Cartographer is a system that provides real-time simultaneous localization and mapping (SLAM) in 2D and 3D across multiple platforms and sensor     configurations."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

ROS_BRANCH ?= "branch=ros2"
SRC_URI = "git://github.com/ros2/cartographer;${ROS_BRANCH};protocol=https \
           file://0001-Fix-compilation-errors-and-add-our-feature.patch \
           file://0002-cmake-Add-FindLua-module-with-Lua-5.5-support.patch \
           file://0003-Fix-Werror-return-type-with-miniglog-LOG-FATAL.patch \
"
SRCREV = "ddfd4414ef2907b6c46a195f1d4e380beedce05d"

S = "${UNPACKDIR}/${BP}"
PATCH_DIR = "${UNPACKDIR}/${BP}"
do_patch() {
    cd ${PATCH_DIR}
    git apply ${UNPACKDIR}/0001-Fix-compilation-errors-and-add-our-feature.patch
    git apply ${UNPACKDIR}/0002-cmake-Add-FindLua-module-with-Lua-5.5-support.patch
    git apply ${UNPACKDIR}/0003-Fix-Werror-return-type-with-miniglog-LOG-FATAL.patch
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

# Suppress -Werror=return-type: ceres miniglog LOG(FATAL) is not [[noreturn]],
# causing false "control reaches end of non-void function" errors with GCC 15.
CXXFLAGS:append = " -Wno-error=return-type"

DEPENDS += " \
    protobuf-native \
"

# Doesn't need runtime dependency on ceres-solver
ROS_EXEC_DEPENDS:remove = "ceres-solver"

do_package_qa[noexec] = "1"

# ceres is compiled with miniglog which lacks several glog macros/variables.
# Patch the miniglog stub in the sysroot to add the missing symbols so that
# cartographer source files that include <glog/logging.h> via miniglog compile.
do_configure:prepend() {
    MINIGLOG="${RECIPE_SYSROOT}/usr/include/ceres/internal/miniglog/glog/logging.h"
    if [ -f "${MINIGLOG}" ] && ! grep -q "LOG_EVERY_N" "${MINIGLOG}"; then
        python3 -c "
import re
path = '${MINIGLOG}'
with open(path) as f:
    content = f.read()
compat = '''
/* --- cartographer compat: macros missing from miniglog --- */
#ifndef LOG_EVERY_N
#define LOG_EVERY_N(severity, n) LOG(severity)
#endif
#ifndef LOG_IF_EVERY_N
#define LOG_IF_EVERY_N(severity, condition, n) LOG_IF(severity, condition)
#endif
#ifndef CHECK_NEAR
#define CHECK_NEAR(val1, val2, margin) \\\\\\\\
    CHECK_LE(::std::abs((val1) - (val2)), (margin))
#endif
#ifndef FLAGS_logtostderr
inline bool FLAGS_logtostderr = false;
#endif
/* --- end cartographer compat --- */
'''
content = content.replace('#endif  // CERCES_INTERNAL_MINIGLOG_GLOG_LOGGING_H_',
                           compat + '#endif  // CERCES_INTERNAL_MINIGLOG_GLOG_LOGGING_H_')
with open(path, 'w') as f:
    f.write(content)
"
    fi
}

inherit ros_${ROS_BUILD_TYPE} robotics-package

