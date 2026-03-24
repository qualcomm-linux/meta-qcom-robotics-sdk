inherit ros_distro_${ROS_DISTRO}
inherit ros_component robotics-package pkgconfig
inherit pkgconfig cmake

LICENSE  = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=550794465ba0ec5312d6919e203a55f9"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_camera.git;protocol=https;branch=stable/2.0.2;subpath=qrb_ros_camera \
           file://0001-patch-update-for-qrb_ros_camera.patch"
SRCREV = "5f88780ea9ef7c5df3d1c08899bdb89fbecbfab8"
S = "${UNPACKDIR}/qrb_ros_camera"

# Dependencies
CAMERA_ROS2_NODE_DEPENDS = " \
    qrb-ros-transport-image-type \
    qrb-camera \
"

ROS_BUILD_DEPENDS = " \
    rclcpp \
    sensor-msgs \
    rclcpp-components \
    cv-bridge \
    yaml-cpp \
    image-transport \
    camera-info-manager \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
"

DEPENDS = "${CAMERA_ROS2_NODE_DEPENDS} ${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"

ROS_EXEC_DEPENDS = " \
    rclcpp \
    rclcpp-components \
    sensor-msgs \
    qrb-ros-transport-image-type \
"
ROS_TEST_DEPENDS = " \
    ament-lint-auto \
    ament-lint-common \
    ament-cmake-gtest \
    ament-cmake-copyright \
    ament-cmake-cppcheck \
    ament-cmake-cpplint \
    ament-cmake-flake8 \
    ament-cmake-lint-cmake \
    ament-cmake-pep257 \
    ament-cmake-uncrustify \
    ament-cmake-xmllint \
"
ROS_EXPORT_DEPENDS = " \
    rclcpp \
"
ROS_BUILDTOOL_EXPORT_DEPENDS = ""

DEPENDS += "pkgconfig-native"
DEPENDS = "${CAMERA_ROS2_NODE_DEPENDS} ${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS} ${ROS_TEST_DEPENDS}"

EXTRA_OECMAKE  += "-DSYSROOT_INCDIR=${RECIPE_SYSROOT}/usr/include"
EXTRA_OECMAKE  += "-DSYSROOT_LIBDIR=${RECIPE_SYSROOT}/usr/lib"

RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

ROS_BUILD_TYPE = "ament_cmake"
inherit ros_${ROS_BUILD_TYPE}

FILES:${PN} += " \
    ${pkg_dest}${includedir} "

EXTRA_OECMAKE:append = " -DBUILD_TESTING=ON"

