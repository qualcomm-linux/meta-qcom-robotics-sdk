inherit ros_distro_${ROS_DISTRO} pkgconfig
inherit robotics-package

DESCRIPTION = "Provide the docker image for running and developing QRB ROS Jazzy packages"
AUTHOR = "Na Song <nasong@qti.qualcomm.com>"
ROS_AUTHOR = "Na Song"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b261acfe37cea70c4bed63dfe6ad1ff4"

ROS_CN = "qrb_ros_docker"
ROS_BPN = "qrb_ros_docker"

SRC_URI = "git://github.com/qualcomm-qrb-ros/qrb_ros_docker.git;protocol=https;branch=stable/1.0.0"
SRCREV = "ec667658c0ad9c329fc19622dd65d336cd718f86"

do_install() {
    install -d ${D}${datadir}/qrb_ros_docker/dockerfile
    install -d ${D}${datadir}/qrb_ros_docker/scripts

    cp -r ${S}/dockerfile/* ${D}${datadir}/qrb_ros_docker/dockerfile/
    cp -r ${S}/scripts/* ${D}${datadir}/qrb_ros_docker/scripts/
}

FILES:${PN} += " \
    ${datadir}/qrb_ros_docker/dockerfile \
    ${datadir}/qrb_ros_docker/scripts \
"