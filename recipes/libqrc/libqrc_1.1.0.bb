inherit ros_distro_${ROS_DISTRO}
inherit ros_component
DESCRIPTION = "Library for the qcom-robotic-controller user driver"
SECTION = "libs"
LICENSE          = "BSD-3-Clause-Clear"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a"
# ros build time dependency start
ROS_BUILD_DEPENDS = " \
    libqrc-udriver \
"
ROS_BUILDTOOL_DEPENDS = ""
ROS_EXPORT_DEPENDS = ""
ROS_BUILDTOOL_EXPORT_DEPENDS = ""
# build time dependency end
# ros runtime dependency start
ROS_EXEC_DEPENDS = " \
    libqrc-udriver \
"
# ros runtime dependency end
ROS_TEST_DEPENDS = ""
DEPENDS = "${ROS_BUILD_DEPENDS} ${ROS_BUILDTOOL_DEPENDS}"
DEPENDS += "${ROS_EXPORT_DEPENDS} ${ROS_BUILDTOOL_EXPORT_DEPENDS}"
RDEPENDS:${PN} += "${ROS_EXEC_DEPENDS}"
SRC_URI = "git://github.com/qualcomm-qrb-ros/libqrc.git;protocol=https;branch=stable/1.1.1"
S = "${UNPACKDIR}/${BP}/libqrc"
SRCREV = "6cb9f2a9b90d24abb6691ed58b1a3a742041003b"
# define the build type : ament_cmake, ament_python, cmake etc...
ROS_BUILD_TYPE = "ament_cmake"
inherit ros_${ROS_BUILD_TYPE}
inherit robotics-package
