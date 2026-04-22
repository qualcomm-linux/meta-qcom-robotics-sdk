inherit pkgconfig cmake

DESCRIPTION = "QRB Audio Common library"
AUTHOR = "Ronghui Zhu <quic_ronghuiz@quicinc.com>"
ROS_AUTHOR = "Ronghui Zhu"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=68c28a8a26024c85c589d0de638520b6"

PV = "1.0.3"

DEPENDS = "glog gflags"

SRC_URI = "git://github.com/quic-qrb-ros/qrb_ros_audio_service.git;protocol=https;branch=stable/1.0.3 \
           file://0001-fix-record-volume-too-low.patch;striplevel=2 \
           "

SRCREV = "7a6e720cbd0a649432461a41069e880647c5c2be"
S = "${UNPACKDIR}/${BP}/qrb_audio_common_lib"

DEPENDS += " \
    pulseaudio \
    libsndfile1 \
"

EXTRA_OECMAKE:append = " -DBUILD_TESTING=OFF"

FILES:${PN}-dev += "${datadir}"
