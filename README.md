# Welcome to Qualcomm Intelligent Robotics Product (QIRP) SDK

This is the layer designed to generate **QIRP**(**Q**ualcomm **I**ntelligent **R**obotics **P**roduct) SDK. The QIRP SDK is designed to deliver out-of-box robotics samples and easy-to-develop experience on Qualcomm robotics platforms.

This documentation is intended to help you understand the basic features of the QIRP SDK and get started it quickly. And you will learn:

- What is the QIRP SDK
- How to sync and build QIRP SDK
- How to install QIRP SDK
- How to run samples on QIRP SDK
- How to develop application with QIRP SDK

# What is the QIRP SDK

Welcome to use the Qualcomm® Intelligent Robotics Product SDK (QIRP SDK) 2.0. This SDK is applicable to the Qualcomm® Linux releases. QIRP SDK is a collection of components that enable a developer to realize robotics features on Qualcomm Platforms. The QIRP SDK provides the following:

**Out-of-box samples**

- ROS packages serve as a reference or code base for helping developers quickly develop their Robotics applications.
- E2E scenario samples. Help developers evaluate the robotics platforms as systematic solution.

**Easy-to-develop experience**

- Various ROS packages for robotics applications.
- Integrated cross-compile toolchain, which includes common build tools, such as `aarch64-oe-linux-gcc`, `make`, `cmake`, and ROS core. Developers can build their applications with their familiar approaches.
- Tools and scripts to help customers accelerate the development.
- Documents that describe how to set up the QIRP SDK and tutorials on how to quickly start to develop your own applications.

The purpose of this document is to help a developer get started with the QIRP SDK. The scope of this document primarily covers how to generate the QIRP SDK, install QIRP SDK, run sample applications, and guide you through developing your first sample application.

# How to sync and build QIRP SDK

## Prerequisites

Run the following commands to set up Qualcomm Package Manager 3 [https://qpm.qualcomm.com/](https://qpm.qualcomm.com/):

```shell
mkdir -p <DEV_PKG_LOCATION>
cd <DEV_PKG_LOCATION>
sudo dpkg -i <downloaded Deb file>
## Example `sudo dpkg -i QualcommPackageManager3.3.0.92.4.Linux-x86.deb`
qpm-cli --login
```
## Host Setup and Download the Yocto Project BSP

Refer to https://github.com/quic-yocto/qcom-manifest/blob/qcom-linux-kirkstone/README.md setup the host environment and sync the latest Yocto Project BSP.
## Download the layers for QIRP SDK

Based on the `<workspace>` directory of the downloaded Yocto Project BSP, execute the following command to download the required layers.

```shell
cd <workspace>
git clone https://git.codelinaro.org/clo/le/meta-ros.git -b ros.qclinux.1.0.r1-rel layers/meta-ros
git clone https://github.com/quic-yocto/meta-qcom-robotics.git layers/meta-qcom-robotics
git clone https://github.com/quic-yocto/meta-qcom-robotics-distro.git layers/meta-qcom-robotics-distro
git clone https://github.com/quic-yocto/meta-qcom-robotics-sdk.git layers/meta-qcom-robotics-sdk
git clone https://github.com/quic-yocto/meta-qcom-qim-product-sdk layers/meta-qcom-qim-product-sdk
```

## Build QIRP SDK

```shell
cd <workspace>
ln -s layers/meta-qcom-robotics-distro/set_bb_env.sh ./setup-robotics-environment
ln -s layers/meta-qcom-robotics-sdk/scripts/qirp-build ./qirp-build

MACHINE=qcm6490 DISTRO=qcom-robotics-ros2-humble source setup-robotics-environment

../qirp-build qcom-robotics-full-image
```

QIRP SDK artifacts: `<workspace>/build-qcom-robotics-ros2-humble/tmp-glibc/deploy/qirpsdk_artifacts/qirp-sdk_<version>.tar.gz`

Robotics image: `<workspace>/build-qcom-robotics-ros2-humble/tmp-glibc/deploy/images/qcm6490/qcom-robotics-full-image/`

# How to install QIRP SDK
 

**Flash robotics image**

1. Connect the device to the host machine. Refer to [Set up the device](https://docs.qualcomm.com/bundle/publicresource/topics/80-70014-253/set_up_the_device.html) of the [Qualcomm® Robotics RB3 Gen2 Development Kit Quick Start Guide](https://docs.qualcomm.com/bundle/publicresource/topics/80-70014-253)
2. Flash the robotics image to the device. Refer to the [Qualcomm® Robotics RB3 Gen2 Development Kit Quick Start Guide](https://docs.qualcomm.com/bundle/publicresource/topics/80-70014-253), using the robotics image generated with previous steps.

**Install QIRP SDK on the device**

1. On the host machine, move to the artifacts directory and decompress the package using the `tar` command.

```bash
cd <workspace>/build-qcom-robotics-ros2-humble/tmp-glibc/deploy/qirpsdk_artifacts
tar -zxf qirp-sdk_<qirp_version>.tar.gz
```

> **Note:** The `qirp-sdk_<qirp_version>.tar.gz` is in the deployed path of QIRP artifacts. The `<qirp_version>` changes with each release, such as `2.0.0`, `2.0.1`. For example, the whole package name can be `qirp-sdk_2.0.0.tar.gz`. For all released versions, see the _QIRP SDK release notes_.

2. To deploy the QIRP artifacts, push the QIRP files to the device using the following commands.
```bash
cd <workspace>/build-qcom-robotics-ros2-humble/tmp-glibc/deploy/qirpsdk_artifacts/qirp-sdk
adb devices
adb push ./runtime/qirp-sdk.tar.gz /opt/
adb shell "cd /opt && tar -zxf ./qirp-sdk.tar.gz"
adb shell "chmod +x /opt/qirp-sdk/*.sh"
adb shell "cd /opt/qirp-sdk && ./install.sh"
```

# How to run samples on QIRP SDK

The QIRP SDK provides the sample applications that users can run to experience the basic functionality on the device.

Example: System Monitor ROS Node publish system information with ROS messages, such as CPU loading, memory usage, battery status.

**Set up the cross-compile environment**

```bash
cd <QIRP_decompressed_path>/qirp-sdk
source setup.sh
```

**Build the sample**

```bash
cd sample-code/Applications/QRB-ROS/qrb_ros_system_monitor
export AMENT_PREFIX_PATH="${OECORE_TARGET_SYSROOT}/usr;${OECORE_NATIVE_SYSROOT}/usr"
export PYTHONPATH=${PYTHONPATH}:${OECORE_TARGET_SYSROOT}/usr/lib/python3.10/site-packages
colcon build --merge-install --cmake-args \
 -DPython3_ROOT_DIR=${OECORE_TARGET_SYSROOT}/usr \
 -DPython3_NumPy_INCLUDE_DIR=${OECORE_TARGET_SYSROOT}/usr/lib/python3.10/site-packages/numpy/core/include \
 -DPYTHON_SOABI=cpython-310-aarch64-linux-gnu -DCMAKE_STAGING_PREFIX=$(pwd)/install \
 -DCMAKE_PREFIX_PATH=$(pwd)/install/share \
 -DBUILD_TESTING=OFF
```

**Install the system monitor to device**

```bash
adb wait-for-device
cd sample-code/Applications/QRB-ROS/qrb_ros_system_monitor/install
tar czvf qrb_ros_system_monitor.tar.gz include lib share
adb push qrb_ros_system_monitor.tar.gz /opt/qcom/qirp-sdk/
adb shell "tar -zxf /opt/qcom/qirp-sdk/qrb_ros_system_monitor.tar.gz -C /opt/qcom/qirp-sdk/usr/"
```

**In terminal 1, run the system monitor node**

```bash
adb shell
export HOME=/opt
source /usr/bin/ros_setup.sh && source /etc/profile.d/qirp-setup.sh
ros2 run qrb_ros_system_monitor qrb_ros_system_monitor
```

**In terminal 2, check the ROS topic and message.**

Check ROS topic:

```bash

adb shell
export HOME=/opt
source /usr/bin/ros_setup.sh && source /etc/profile.d/qirp-setup.sh
ros2 topic list
	/battery
	/cpu
	/disk
	/memory
	/parameter_events
	/rosout
	/swap
	/temperature
```

Check ROS message:

```bash
ros2 topic list
ros2 topic echo /cpu
```

# How to develop application with QIRP SDK

The following example provides a general procedure for developing your first application using the QIRP SDK.

## Set up the cross-compile environment

```bash
cd <QIRP_decompressed_path>/qirp-sdk
source setup.sh
```

## Fetch the project and write your own code

**Fetch a project from github**

```bash
git clone https://github.com/ros2/demos.git -b humble
cd demos/demo_nodes_cpp
vim src/topics/talker.cpp
```

**Develop your own application. Following is a sample.**

Change the `demo_nodes_cpp/src/topics/talker.cpp` msg data in line46, such as changing 'Hello world' to 'get message success'：

```css
46:msg_->data = "get message success " + std::to_string(count_++);
```

## Compile the application

```bash
export AMENT_PREFIX_PATH="${OECORE_TARGET_SYSROOT}/usr;${OECORE_NATIVE_SYSROOT}/usr"
export PYTHONPATH=${PYTHONPATH}:${OECORE_TARGET_SYSROOT}/usr/lib/python3.10/site-packages
colcon build --merge-install --cmake-args \
-DPython3_ROOT_DIR=${OECORE_TARGET_SYSROOT}/usr \
-DPython3_NumPy_INCLUDE_DIR=${OECORE_TARGET_SYSROOT}/usr/lib/python3.10/site-packages/numpy/core/include \
-DCMAKE_STAGING_PREFIX=$(pwd)/install \
-DCMAKE_PREFIX_PATH=$(pwd)/install/share \
-DBUILD_TESTING=OFF \
--packages-up-to demo_nodes_cpp
```

## Push the demo to device

```bash
cd demo_nodes_cpp/install
tar -czvf demo_nodes_cpp.tar.gz lib share
adb devices
adb push demo_nodes_cpp.tar.gz /opt/qcom/qirp-sdk/
adb shell "tar -zxf /opt/qcom/qirp-sdk/demo_nodes_cpp.tar.gz -C /opt/qcom/qirp-sdk/usr/"
```

## Run the demo application on the device

```bash
export HOME=/opt
source /usr/bin/ros_setup.sh && source /etc/profile.d/qirp-setup.sh
 
shell 1: ros2 run demo_nodes_cpp talker
shell 2: ros2 run demo_nodes_cpp listener
```

# Reference

[Standard Yocto environment](https://docs.yoctoproject.org/4.0.13/brief-yoctoprojectqs/index.html)

[QCOM Linux Yocto BSP releases](https://github.com/quic-yocto/qcom-manifest/blob/qcom-linux-kirkstone/README.md)
