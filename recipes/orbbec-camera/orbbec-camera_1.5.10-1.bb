inherit ros_distro_${ROS_DISTRO}
inherit ros_component
inherit pkgconfig

DESCRIPTION = "Orbbec Camera package"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

ROS_CN = "orbbec_camera"
ROS_BPN = "orbbec_camera"

SRC_URI = "git://github.com/orbbec/OrbbecSDK_ROS2.git;protocol=https;branch=v2-main \
           file://0001-Fix-orbbec-camera-compilation-error.patch \
"

SRCREV = "0a22657f77d783650bffa446b4a1a6395b04bf76"
S = "${UNPACKDIR}/${BP}/orbbec_camera"

PATCH_DIR = "${UNPACKDIR}/${BP}"

# ---- Fix TMPDIR buildpaths: compiler/debug paths ----
TARGET_CC_ARCH:append = " ${DEBUG_PREFIX_MAP}"
CFLAGS:append        = " ${DEBUG_PREFIX_MAP}"
CXXFLAGS:append      = " ${DEBUG_PREFIX_MAP}"
ASFLAGS:append       = " ${DEBUG_PREFIX_MAP}"

do_patch() {
    cd ${PATCH_DIR}
    patch -p1 < ${UNPACKDIR}/0001-Fix-orbbec-camera-compilation-error.patch
}

ROS_BUILD_DEPENDS = " \
    rosidl-default-generators-native \
    rosidl-default-runtime \
    ament-index-cpp \
    image-transport \
    image-publisher \
    rclcpp-components \
    cv-bridge \
    camera-info-manager \
    orbbec-camera-msgs \
    builtin-interfaces \
    rclcpp \
    sensor-msgs \
    std-msgs \
    std-srvs \
    tf2 \
    tf2-ros \
    tf2-sensor-msgs \
    tf2-eigen \
    tf2-msgs \
    diagnostic-updater \
    diagnostic-msgs \
    backward-ros \
    eigen3-cmake-module-native \
    nlohmann-json \
    gflags \
    glog \
    opencv \
    libeigen \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
"

ROS_EXEC_DEPENDS = " \
    rosidl-default-runtime \
    ament-index-cpp \
    image-transport \
    image-publisher \
    rclcpp-components \
    cv-bridge \
    camera-info-manager \
    orbbec-camera-msgs \
    builtin-interfaces \
    rclcpp \
    sensor-msgs \
    std-msgs \
    std-srvs \
    tf2 \
    tf2-ros \
    tf2-sensor-msgs \
    tf2-eigen \
    tf2-msgs \
    diagnostic-updater \
    diagnostic-msgs \
    nlohmann-json \
    backward-ros \
"

NON_ROS_EXEC_DEPENDS = " \
    gflags \
    glog \
    opencv \
    libeigen \
    nlohmann-json \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS} ${NON_ROS_EXEC_DEPENDS}"

FILES:${PN}:prepend = "${datadir}/orbbec_camera"
FILES:${PN} += "${libdir}/*"

# Fix QA: buildpaths (TMPDIR leak) - avoid embedding build RPATH
EXTRA_OECMAKE:append = " \
    -DCMAKE_SKIP_RPATH=ON \
    -DCMAKE_SKIP_INSTALL_RPATH=ON \
    -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF \
"

ROS_BUILD_TYPE = "ament_cmake"

do_install:append() {
    # Sanitize ament cmake export files to remove build paths
    if [ -d ${D}/usr/ros/${ROS_DISTRO}/share/orbbec_camera/cmake ]; then
        sed -i \
            -e "s|${TMPDIR}||g" \
            -e "s|${WORKDIR}||g" \
            -e "s|${B}||g" \
            ${D}/usr/ros/${ROS_DISTRO}/share/orbbec_camera/cmake/*.cmake || true
    fi
}
INSANE_SKIP:${PN} += "already-stripped"

inherit ros_${ROS_BUILD_TYPE} robotics-package
INSANE_SKIP:${PN} += "ldflags rpaths file-rdeps"
