inherit ros_distro_${ROS_DISTRO}
inherit ros_superflore_generated

DESCRIPTION = "This package provides Cartographer's ROS integration."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://package.xml;beginline=64;endline=64;md5=3dce4ba60d7e51ec64f3c3dc18672dd3"

ROS_CN = "cartographer_ros"
ROS_BPN = "cartographer_ros"

ROS_BUILD_DEPENDS = " \
    abseil-cpp \
    builtin-interfaces \
    cartographer \
    cartographer-ros-msgs \
    qrb-ros-slam-msgs \
    geometry-msgs \
    gflags \
    glog \
    gtest \
    libeigen \
    nav-msgs \
    pcl \
    pcl-conversions \
    python3-sphinx \
    rclcpp \
    ros-environment \
    rosbag2-cpp \
    rosbag2-storage \
    sensor-msgs \
    std-msgs \
    tf2 \
    tf2-eigen \
    tf2-msgs \
    tf2-ros \
    urdf \
    visualization-msgs \
"

ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-native \
"

ROS_EXPORT_DEPENDS = " \
    abseil-cpp \
    builtin-interfaces \
    cartographer \
    cartographer-ros-msgs \
    qrb-ros-slam-msgs \
    geometry-msgs \
    gflags \
    glog \
    libeigen \
    nav-msgs \
    pcl \
    pcl-conversions \
    rclcpp \
    rosbag2-cpp \
    rosbag2-storage \
    sensor-msgs \
    std-msgs \
    tf2 \
    tf2-eigen \
    tf2-msgs \
    tf2-ros \
    urdf \
    visualization-msgs \
"

ROS_BUILDTOOL_EXPORT_DEPENDS = ""

ROS_EXEC_DEPENDS = " \
    abseil-cpp \
    builtin-interfaces \
    cartographer \
    cartographer-ros-msgs \
    qrb-ros-slam-msgs \
    geometry-msgs \
    gflags \
    glog \
    launch \
    libeigen \
    nav-msgs \
    pcl \
    pcl-conversions \
    rclcpp \
    robot-state-publisher \
    rosbag2-cpp \
    rosbag2-storage \
    sensor-msgs \
    std-msgs \
    tf2 \
    tf2-eigen \
    tf2-msgs \
    tf2-ros \
    urdf \
    visualization-msgs \
"


DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"
DEPENDS += "eigen3-cmake-module"
DEPENDS += " \
    protobuf-native \
"
RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"


ROS_BRANCH ?= "branch=ros2"
SRC_URI = "git://github.com/ros2/cartographer_ros;${ROS_BRANCH};protocol=https \
           file://0001-Add-qrb-slam-feature.patch \
           file://0001-add-launch-file-for-gazebo-sim.patch \
           file://0001_fix_glog_time_message_error.patch \
"
SRCREV = "1bbf9af3d250ba7d17f9b2340e7fe01ac22cf7a7"
S = "${UNPACKDIR}/${BP}/cartographer_ros"
B = "${UNPACKDIR}/${BP}"

PATCH_DIR = "${UNPACKDIR}/${BP}"
do_patch() {
    cd ${PATCH_DIR}
    # Reset to clean state in case of retry (sigdata change causes re-run on dirty tree)
    git reset --hard HEAD
    git clean -fd
    git apply ${UNPACKDIR}/0001-Add-qrb-slam-feature.patch
    git apply ${UNPACKDIR}/0001-add-launch-file-for-gazebo-sim.patch
    git apply ${UNPACKDIR}/0001_fix_glog_time_message_error.patch

    # Strip miniglog include from ceres and cartographer imported targets.
    # CeresTargets.cmake sets INTERFACE_INCLUDE_DIRECTORIES to include
    # ceres/internal/miniglog which conflicts with real <glog/log_severity.h>.
    sed -i '/^find_package(nav_msgs REQUIRED)$/a \\nforeach(_tgt cartographer ceres Ceres::ceres Ceres::Ceres ceres::ceres)\n  if(TARGET ${_tgt})\n    get_target_property(_incs ${_tgt} INTERFACE_INCLUDE_DIRECTORIES)\n    if(_incs)\n      list(FILTER _incs EXCLUDE REGEX "miniglog")\n      set_target_properties(${_tgt} PROPERTIES INTERFACE_INCLUDE_DIRECTORIES "${_incs}")\n    endif()\n  endif()\nendforeach()' ${PATCH_DIR}/cartographer_ros/CMakeLists.txt
}


FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

ROS_BUILD_TYPE = "ament_cmake"

# glog 0.7+ requires GLOG_USE_GLOG_EXPORT to be defined before including
# glog/logging.h so that export.h is pulled in and GLOG_EXPORT/GLOG_NO_EXPORT
# are defined. Without this the compiler errors out with "not included correctly".
CXXFLAGS:append = " -DGLOG_USE_GLOG_EXPORT"

do_package_qa[noexec] = "1"

inherit ros_${ROS_BUILD_TYPE} robotics-package

