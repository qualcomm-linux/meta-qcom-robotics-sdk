# Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

# To include host packages in SDK
#TOOLCHAIN_HOST_TASK:append = " nativesdk-protobuf-compiler "

# To include target packages in SDK
#TOOLCHAIN_TARGET_TASK:append = " resize-partitions"

#TOOLCHAIN_TARGET_TASK:append = " opencv"


# To provide tools for ROS node compile in SDK
TOOLCHAIN_HOST_TASK:append = "${@bb.utils.contains_any('DISTRO_FEATURES', 'ros2-humble ros2-jazzy', ' \
    nativesdk-ament-package \
    nativesdk-python3-colcon-common-extensions \
    nativesdk-python3-numpy \
    nativesdk-rosidl-adapter \
    nativesdk-rosidl-cli \
    nativesdk-rosidl-cmake \
    nativesdk-rosidl-generator-c \
    nativesdk-rosidl-generator-cpp \
    nativesdk-rosidl-parser \
    nativesdk-rosidl-typesupport-c \
    nativesdk-rosidl-typesupport-cpp \
    nativesdk-rosidl-typesupport-fastrtps-c \
    nativesdk-rosidl-typesupport-fastrtps-cpp \
    nativesdk-rosidl-typesupport-introspection-c \
    nativesdk-rosidl-typesupport-introspection-cpp \
', '', d)}"

# To provide libs for ROS node compile in SDK
ROS_SDK_TARGET_PACKAGES:append = "${@bb.utils.contains('DISTRO_FEATURES', 'ros2-jazzy', ' \
    python-cmake-module \
', '', d)}"


TOOLCHAIN_TARGET_TASK:remove = "qirp-sdk"

# Add default packages from meta-ros ros-sdk.inc
TOOLCHAIN_HOST_TASK:append = " ${ROS_SDK_HOST_PACKAGES}"

TOOLCHAIN_TARGET_TASK:append = " \
    ${ROS_SDK_TARGET_PACKAGES} \
    sed \
    fmt-staticdev \
    octomap-staticdev \
    osqp-vendor-staticdev \
"

# protobuf-camx recipe was removed from meta-qcom; replace with nativesdk-protobuf-compiler
TOOLCHAIN_HOST_TASK:remove = "nativesdk-protobuf-camx-compiler"
TOOLCHAIN_HOST_TASK:append = " nativesdk-protobuf-compiler"
# Avoid buildtools-tarball recipe packages the host *.armv8_2a.rpm for do_populate_sdk task
TOOLCHAIN_TARGET_TASK:append = "${@(' ' + (d.getVar('ROS_SDK_TARGET_PACKAGES') or '')) if d.getVar('PN') != 'buildtools-tarball' else ''}"

TOOLCHAIN_HOST_TASK:append = "${@(' ' + (d.getVar('ROS_SDK_HOST_PACKAGES') or '')) if d.getVar('PN') != 'buildtools-tarball' else ''}"
