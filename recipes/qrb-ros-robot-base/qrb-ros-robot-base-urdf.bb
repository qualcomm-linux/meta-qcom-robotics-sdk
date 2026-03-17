inherit ros_distro_${ROS_DISTRO}
inherit ros_component

DESCRIPTION = "The QCOM AMR URDF ROS2 package"
LICENSE          = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a"

# ros build time dependency start
ROS_BUILD_DEPENDS = " \
    urdf \
"
ROS_BUILDTOOL_DEPENDS = " \
    ament-cmake-auto-native \
    ament-cmake-ros-native \
"

ROS_EXPORT_DEPENDS = ""
ROS_BUILDTOOL_EXPORT_DEPENDS = ""
# build time dependency end

# ros runtime dependency start
ROS_EXEC_DEPENDS = " \
    urdf \
"
# ros runtime dependency end

ROS_TEST_DEPENDS = ""

# convert ROS BUILD DEPENDS to Yocto DEPENDS
DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"

# convert ROS_EXEC_DEPENDS to Yocto RDEPENDS
RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_robot_base.git;protocol=https;branch=main \
"
S = "${UNPACKDIR}/${BP}/qrb_ros_robot_base_urdf"

SRCREV = "3b71c18c5a64d6b1e147501e1d7677f4ae62baa3"

FILES:${PN}:prepend = "${datadir}/*"

# define the build type : ament_cmake, ament_python, cmake etc...
ROS_BUILD_TYPE = "ament_cmake"
inherit ros_${ROS_BUILD_TYPE}

inherit robotics-package
