inherit ros_distro_${ROS_DISTRO}
inherit ros_component

ROS_BUILD_TYPE = "ament_cmake"

inherit ros_${ROS_BUILD_TYPE}
inherit cmake

ROS_BUILD_TYPE = "ament_cmake"

ROS_CN = "simulation_sample_pick_and_place"
ROS_BPN = "simulation_sample_pick_and_place"

S = "${WORKDIR}/git/robotics/${ROS_CN}"

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
    cmake-native \
    ament-cmake-auto-native \
    ament-cmake-ros-native \
"

ROS_EXPORT_DEPENDS = " \
"

ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
"

ROS_EXEC_DEPENDS = "${ROS_BUILD_DEPENDS}"

DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS} ${ROS_EXPORT_DEPENDS} ${ROS_TEST_DEPENDS}"
DEPENDS += "pkgconfig-native"
RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

EXTRA_OECMAKE = " \
    -DCMAKE_SYSROOT=${STAGING_DIR_TARGET} \
    -DBUILD_TESTING=OFF \
"

FILES:${PN} += " \
    ${libdir}/${ROS_CN}/* \
    ${datadir}/${ROS_CN}/* \
"

require include/qrb-ros-samples.inc

