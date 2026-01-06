#License applicable to the recipe file only,  not to the packages installed by this recipe.
LICENSE = "BSD-3-Clause-Clear"

inherit fsdk-base fsdk-package packagegroup

TARGET_SDK = "robotics"

SDK_PN = "${TARGET_SDK}-sdk"
PV = "2.0.0"

S = "${UNPACKDIR}"

PACKAGE_ARCH = "${MACHINE_ARCH}"

# ROBOTICS_ARCH default with PACKAGE_ARCH, debain : aarch64 -> arm64
# IMAGE_PKGTYPE : debian : deb , yocto default : ipk
# Add the packages into robotics sdk

FUNCTION = " "
BASIC_DEPENDENCY = " "

# FUNCTION:append = " \
#     lib-mem-dmabuf \
#     qrb-sensor-client \
#     qrb-ros-transport-image-type \
#     qrb-ros-transport-imu-type \
#     qrb-ros-transport-point-cloud2-type \
#     qrb-colorspace-convert-lib \
#     qrb-ros-colorspace-convert \
#     qrb-ros-benchmark \
#     dmabuf-transport \
#     qrb-ros-system-monitor \
#     qrb-ros-system-monitor-interfaces \
#     rplidar-ros2 \
#     qrb-audio-common-lib \
#     qrb-audio-service-lib \
#     qrb-ros-audio-common \
#     qrb-ros-audio-common-msgs \
#     qrb-ros-audio-service \
#     qrb-ros-audio-service-msgs \
# "
# FUNCTION:append:qcom-custom-bsp = " \
#     ocr-service \
#     ocr-msg \
#     libqrc-udriver \
#     libqrc \
#     cartographer-ros \
#     qrb-ros-battery \
#     orbbec-description \
#     orbbec-camera-msgs \
#     orbbec-camera \
#     qrb-ros-camera \
#     ugv-sdk \
#     ranger-mini-msg \
#     ranger-mini-base \
#     ranger-mini-bringup \
#     qrb-robot-base-manager \
#     qrb-ros-robot-base-keyboard \
#     qrb-ros-robot-base-urdf \
#     qrb-ros-robot-base \
#     qrb-ros-video \
#     qrb-ros-nn-inference \
#     qrb-yolo-process-lib \
#     qrb-ros-yolo-process \
#     qrb-ros-cv-tensor-common-process \
#     nav2-bringup \
#     qrb-ros-docker \
#     qrb-follow-path-manager \
#     qrb-ros-follow-path \
#     qrb-amr-manager \
#     qrb-ros-amr \
#     ros-gst-bridge-audio-msgs \
#     ros-gst-bridge-msgs \
#     ros-gst-bridge \
#     ros-gst-bridge-pipeline \
#     ros-gst-bridge-pipeline-plugins \
# "

# FUNCTION:remove:qcom-custom-bsp = " realsense2-camera realsense2-camera-msgs librealsense2 "
# FUNCTION:append:qcom-custom-bsp:qcm6490 = " qrb-ros-imu "
# FUNCTION:append:qcom-custom-bsp = " ${@bb.utils.contains_any('BBFILE_COLLECTIONS', 'qcom-robotics', ' follow-me ', '', d)} "

# #basic dependnecy for sdk buildtime and runtime
# BASIC_DEPENDENCY += " \
#     foonathan-memory \
#     foonathan-memory-dev \
#     foonathan-memory-staticdev \
#     opencv \
#     opencv-staticdev \
#     yaml-cpp \
#     zbar \
#     ncnn \
#     libgpiod \
#     graphviz \
#     ceres-solver \
#     ${ROS_SDK_TARGET_PACKAGES} \
# "
# BASIC_DEPENDENCY:append:qcom-custom-bsp = " \
#     sensor-client \
#     battery-client \
#     battery-service \
#     syslog-plumber \
#     qcom-camera-server \
#     ${GL_PROVIDER} \
#     qcom-fastcv-binaries \
# "
BASIC_DEPENDENCY:append:qcom-custom-bsp:qcm6490 = " camxapi-kt-dev "

RDEPENDS:${PN} = "${FUNCTION} ${BASIC_DEPENDENCY}"

do_package_qa[noexec] = "1"

