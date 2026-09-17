inherit pkgconfig cmake

DESCRIPTION = "QRB Audio Service library"
AUTHOR = "Yuchao Pan <yuchpan@qti.qualcomm.com>"
ROS_AUTHOR = "Yuchao Pan"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=68c28a8a26024c85c589d0de638520b6"

PV = "2.0.1"

DEPENDS = "glog gflags"

SRC_URI = "git://github.com/quic-qrb-ros/qrb_ros_audio_service.git;protocol=https;branch=stable/2.0.1"

SRCREV = "32c4bb2d38954f2671a1eba8cf85b01f437f2943"
S = "${UNPACKDIR}/${BP}/qrb_audio_manager"

DEPENDS += " \
    qrb-audio-common-lib \
"

EXTRA_OECMAKE:append = " -DBUILD_TESTING=OFF"

FILES:${PN}-dev += "${datadir}"
