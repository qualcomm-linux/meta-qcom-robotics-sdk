inherit pkgconfig cmake

DESCRIPTION = "A hardware accelerated library implementing video encoding and decoding based on V4L2."
AUTHOR = "Jean Xiao <quic_jianxiao@quicinc.com>"
ROS_AUTHOR = "Jean Xiao"
SECTION = "devel"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=86fcc2294062130b497ba0ffff9f82fc"

PV = "0.1.7"

DEPENDS = "glog gflags"

SRC_URI = "git://github.com/quic-qrb-ros/qrb_ros_video.git;protocol=https;branch=stable/0.1.7 \
           file://0001-fix-make-glog-integration-with-cmake-28.patch;striplevel=2 \
          "

SRCREV = "3b94a5f4ec6cc498fe4161d010f44f5393030173"
S = "${UNPACKDIR}/${BP}/qrb_video_v4l2_lib"

EXTRA_OECMAKE:append = " -DBUILD_TESTING=OFF"

FILES:${PN}-dev += "${datadir}"
