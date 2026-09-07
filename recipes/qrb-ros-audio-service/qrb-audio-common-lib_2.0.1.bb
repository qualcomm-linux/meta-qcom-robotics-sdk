inherit pkgconfig cmake

DESCRIPTION = "QRB Audio Common library"
AUTHOR = "Ronghui Zhu <quic_ronghuiz@quicinc.com>"
ROS_AUTHOR = "Ronghui Zhu"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=68c28a8a26024c85c589d0de638520b6"

PV = "2.0.1"

DEPENDS = "glog gflags"

SRC_URI = "git://github.com/quic-qrb-ros/qrb_ros_audio_service.git;protocol=https;branch=stable/2.0.1 \
           "

SRCREV = "32c4bb2d38954f2671a1eba8cf85b01f437f2943"
S = "${UNPACKDIR}/${BP}/qrb_audio_common_lib"

DEPENDS += " \
    pulseaudio \
    libsndfile1 \
    alsa-lib \
"

EXTRA_OECMAKE:append = " -DBUILD_TESTING=OFF"

FILES:${PN}-dev += "${datadir}"
