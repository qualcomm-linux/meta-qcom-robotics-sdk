inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION = "The AMR ROS2 control interfaces"
LICENSE          = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a"

ROS_BUILD_DEPENDS = " \
    std-msgs \
    service-msgs \
    sensor-msgs \
"

# ros build time dependency start
ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
    ament-cmake-ros-native \
    rosidl-default-generators-native \
    rosidl-default-runtime-native \
"
ROS_EXPORT_DEPENDS = ""
ROS_BUILDTOOL_EXPORT_DEPENDS = ""
# build time dependency end

# ros runtime dependency start
ROS_EXEC_DEPENDS = " \
    std-msgs \
    service-msgs \
    sensor-msgs \
"
# ros runtime dependency end

ROS_TEST_DEPENDS = ""

# convert ROS BUILD DEPENDS to Yocto DEPENDS
DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

# convert ROS_EXEC_DEPENDS to Yocto RDEPENDS
RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_interfaces.git;protocol=https;branch=main \
"
S = "${UNPACKDIR}/${BP}/qrb_ros_robot_base_msgs"

SRCREV = "e20a5f7ad2aa77c538696fb3a47b7cbef77e881c"

# define the build type : ament_cmake, ament_python, cmake etc...
ROS_BUILD_TYPE = "ament_cmake"
inherit ros_${ROS_BUILD_TYPE}

inherit robotics-package

