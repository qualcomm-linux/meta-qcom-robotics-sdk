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

## Host Setup

Refer to [qcom-manifest/README.md](https://github.com/quic-yocto/qcom-manifest/blob/qcom-linux-kirkstone/README.md#host-setup) setup the host environment.

## Prerequisites

Run the following commands to set up Qualcomm Package Manager 3 [https://qpm.qualcomm.com/](https://qpm.qualcomm.com/):

```shell
mkdir -p <DEV_PKG_LOCATION>
cd <DEV_PKG_LOCATION>
sudo dpkg -i <downloaded Deb file>
## Example `sudo dpkg -i QualcommPackageManager3.3.0.92.4.Linux-x86.deb`
qpm-cli --login
```

## Sync the code base of QIRP SDK

```shell
mkdir <workspace>
cd <workspace>
repo init -u https://github.com/quic-yocto/qcom-manifest -b [branch name] -m [release manifest]
repo sync -c -j8
```

**Example:**

To download the `qcom-6.6.17-QLI.1.0-Ver.1.3_robotics.xml` release

```shell
repo init -u https://github.com/quic-yocto/qcom-manifest -b qcom-linux-kirkstone -m qcom-6.6.17-QLI.1.0-Ver.1.3_robotics.xml
repo sync -c -j8
```

## Build QIRP SDK

```shell
cd <workspace>
MACHINE=qcm6490 DISTRO=qcom-robotics-ros2-humble source setup-robotics-environment

../qirp-build qcom-robotics-full-image
```

QIRP SDK artifacts: `<workspace>/build-qcom-robotics-ros2-humble/tmp-glibc/deploy/artifacts/qirp-sdk_<version>.tar.gz`

Robotics image: `<workspace>/build-qcom-robotics-ros2-humble/tmp-glibc/deploy/images/qcm6490/qcom-robotics-full-image/`

# How to install QIRP SDK
 

**Deploy QIRP SDK on the host machine**

On the host machine, move to the artifacts directory and decompress the package using the `tar` command.

```bash
cd <workspace>/build-qcom-robotics-ros2-humble/tmp-glibc/deploy/artifacts
tar -zxf qirp-sdk_<qirp_version>.tar.gz
cd qirp-sdk
```

**Install QIRP SDK on the device**

1. Flash the robotics image to the device. To do this, refer to the [RB3 Gen2 Quick Start Guide](https://docs.qualcomm.com/bundle/publicresource/topics/80-70014-253).
2. Ensure that the device is connected to the host machine.
3. To deploy the QIRP artifacts, push the QIRP files to the device using the following commands.
```bash
adb devices
adb push ./runtime/qirp-sdk.tar.gz /opt/
adb shell "cd /opt && tar -zxf ./qirp-sdk.tar.gz"
adb shell "chmod +x /opt/qirp-sdk/*.sh"
adb shell "cd /opt/qirp-sdk && ./install.sh"
```

# How to run samples on QIRP SDK

The QIRP SDK provides the sample applications that users can run to experience the basic functionality on the device.

Example: System Monitor ROS Node publish system information with ROS messages, such as CPU loading, memory usage, battery status.

**Build the sample**

```bash
cd sample-code/Product_SDK_Samples/Applications/QRB-ROS/qrb_ros_system_monitor
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
cd sample-code/Product_SDK_Samples/Applications/QRB-ROS/qrb_ros_system_monitor/install
tar czvf qrb_ros_system_monitor.tar.gz include lib share
adb push qrb_ros_system_monitor.tar.gz /opt/qcom/qirp-sdk/
adb shell "tar -zxf /opt/qcom/qirp-sdk/qrb_ros_system_monitor.tar.gz -C /opt/qcom/qirp-sdk/usr/"
```

**In terminal 1, run the system monitor node**

```bash
export HOME=/opt
source /usr/bin/ros_setup.sh && source /opt/qcom/qirp-sdk/qirp-setup.sh
ros2 run qrb_ros_system_monitor qrb_ros_system_monitor
```

**In terminal 2, check the ROS topic and message.**

Check ROS topic:

```bash
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
cd <QIRP_decompressed_path>/qirp_sdk
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
cd demo_nodes_cpp\install
tar -czvf demo_nodes_cpp.tar.gz lib share
adb devices
adb push demo_nodes_cpp.tar.gz /opt/qcom/qirp-sdk/
adb shell "tar -zxf /opt/qcom/qirp-sdk/qrb_ros_system_monitor.tar.gz -C /opt/qcom/qirp-sdk/usr/"
```

## Run the demo application on the device

```bash
export HOME=/opt
source /usr/bin/ros_setup.sh && source /opt/qcom/qirp-sdk/qirp-setup.sh
export PATH=/opt/qcom/qirp-sdk/usr/share:/opt/qcom/qirp-sdk/usr/bin:${PATH}
 
shell 1 : ros2 run demo_nodes_cpp talker
shell 2: ros2 run demo_nodes_cpp listener
```

# Reference

[Standard Yocto environment](https://docs.yoctoproject.org/4.0.13/brief-yoctoprojectqs/index.html)

[QCOM Linux Yocto BSP releases](https://github.com/quic-yocto/qcom-manifest/blob/qcom-linux-kirkstone/README.md)
