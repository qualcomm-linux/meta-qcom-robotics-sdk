LICENSE = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a"

inherit ros_distro_${ROS_DISTRO}
inherit ros_component
inherit ros_component robotics-package

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}
inherit cmake

ROS_BUILD_TYPE = "ament_cmake"

ROS_CN = "simulation_sample_pick_and_place"
ROS_BPN = "simulation_sample_pick_and_place"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_samples.git;protocol=https;branch=stable-simulation_sample_pick_and_place/1.0.1"

SRCREV = "66132278d624a1464df6a5e8562f0bd3419d46e6"

# S = "${UNPACKDIR}/${PN}-${PV}/robotics/${ROS_CN}"

ROS_BUILD_DEPENDS = " \
    ament-cmake \
    moveit-msgs \
    moveit-ros-planning-interface \
    rclcpp \
    geometry-msgs \
    trajectory-msgs \
    std-msgs \
    eigen-stl-containers \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

ROS_EXEC_DEPENDS = "${ROS_BUILD_DEPENDS}"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS} pkgconfig-native pkgconfig"
RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

do_configure:prepend() {
    bbnote "== RECIPE_SYSROOT: ${RECIPE_SYSROOT} ==="
    bbnote "== CMAKE_SYSROOT: ${CMAKE_SYSROOT} ==="

    cfg="${RECIPE_SYSROOT}/usr/ros/${ROS_DISTRO}/share/moveit_ros_planning_interface/cmake/ConfigExtras.cmake"
    if [ -f "$cfg" ]; then
        sed -i 's/[[:space:]]system[[:space:]]/ /g; s/[[:space:]]system)//g; s/[[:space:]]system$/ /g' "$cfg"
    fi

    # export PKG_CONFIG_SYSROOT_DIR="${RECIPE_SYSROOT}"
    # export PKG_CONFIG_LIBDIR="${RECIPE_SYSROOT}${libdir}/pkgconfig:${RECIPE_SYSROOT}${datadir}/pkgconfig"
    # unset PKG_CONFIG_PATH

}

FILES:${PN} += " \
    ${libdir}/${ROS_CN}/* \
    ${datadir}/${ROS_CN}/* \
"
