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

## Host Setup and Download the Yocto Project BSP

Refer to https://github.com/qualcomm-linux/qcom-manifest/blob/qcom-linux-kirkstone/README.md setup the host environment.

## Download the layer of QIRP SDK

Based on the `<workspace>` directory of the downloaded Yocto Project BSP, execute the following command to download the required layers.

```shell
cd <workspace>
repo init -u https://github.com/quic-yocto/qcom-manifest -b [branch name] -m [release manifest]
repo sync -c -j8
```

Example:

To download the `qcom-6.6.65-QLI.1.4-Ver.1.0_robotics-product-sdk-1.0.xml   ` release, run this command:

```
repo init -u https://github.com/quic-yocto/qcom-manifest -b qcom-linux-scarthgap -m qcom-6.6.65-QLI.1.4-Ver.1.0_robotics-product-sdk-1.0.xml
repo sync -c -j8
```

## Build QIRP SDK

```shell
cd <workspace>

MACHINE=<Machine_name> DISTRO=<Distro_name>  QCOM_SELECTED_BSP=<Build_override> source setup-robotics-environment <Build_directory>

../qirp-build qcom-robotics-full-image
```

| Parameter | RB3 Gen2 Vision kit | IQ9 | IQ8 |
|---|---|---|---|
| Machine_name | qcs6490-rb3gen2-vision-kit | qcs9075-rb8-core-kit | qcs8300-ride-sx | 
| Distro_name  | qcom-robotics-ros2-jazzy  | qcom-robotics-ros2-jazzy | qcom-robotics-ros2-jazzy |
| Build_override  | custom  | custom | custom |
|   |   | base | base |
| Build_directory  | build-qcs6490-custom  | build-qcs9100-custom | build-qcs8300-custom |
|   |   | build-qcs9100-base | build-qcs8300-base |


Results for different machines:

RB3 Gen2 Vision Kit (qcs6490-rb3gen2-vision-kit)

QIRP SDK artifacts: `<workspace>/build-qcs6490-custom/tmp-glibc/deploy/qirpsdk_artifacts/qirp-sdk_<version>.tar.gz`

Robotics image: `<workspace>/build-qcs6490-custom/tmp-glibc/deploy/images/qcs6490-rb3gen2-vision-kit/qcom-robotics-full-image`

IQ9 (qcs9075-rb8-core-kit, using the custom build override as an example)

QIRP SDK artifacts: `<workspace>/build-qcs9100-custom/tmp-glibc/deploy/qirpsdk_artifacts/qirp-sdk_<version>.tar.gz`

Robotics image: `<workspace>/build-qcs9100-custom/tmp-glibc/deploy/images/qcs9075-rb8-core-kit/qcom-robotics-full-image`

Ride SX (qcs8300-ride-sx, using the custom build override as an example)

QIRP SDK artifacts: `<workspace>/build-qcs8300-custom/tmp-glibc/deploy/qirpsdk_artifacts/qirp-sdk_<version>.tar.gz`

Robotics image: `<workspace>/build-qcs8300-custom/tmp-glibc/deploy/images/qcs8300-ride-sx/qcom-robotics-full-image`

# How to install QIRP SDK

**Flash robotics image**

Flash the robotics image to the device, see the [Flash image](https://docs.qualcomm.com/bundle/publicresource/topics/80-70017-254/flash_images.html?vproduct=1601111740013072&latest=true) , using the robotics image generated with previous steps.

**Prerequisite**

- The prebuilt robotics image is flashed.
- SSH is enabled in ‘Permissive’ mode with the steps mentioned in [Use SSH](https://docs.qualcomm.com/bundle/publicresource/topics/80-70017-254/how_to.html?vproduct=1601111740013072&latest=true#use-ssh).

**Install QIRP SDK on the device**

1. On the host machine, move to the artifacts directory and decompress the package using the `tar` command.

```bash
tar -zxf qirp-sdk_<qirp_version>.tar.gz
```

> **Note:** The `qirp-sdk_<qirp_version>.tar.gz` is in the deployed path of QIRP artifacts. The `<qirp_version>` changes with each release, such as `2.0.0`, `2.0.1`. For example, the whole package name can be `qirp-sdk_2.0.0.tar.gz`. For all released versions, see the _QIRP SDK release notes_.

2. To deploy the QIRP artifacts, push the QIRP files to the device using the following commands.
```bash
cd <qirp_decompressed_workspace>
(ssh) mount -o remount,rw /usr
scp ./runtime/qirp-sdk.tar.gz root@[ip-addr]:/opt/
ssh root@[ip-addr]
(ssh) cd /opt && tar -zxf ./qirp-sdk.tar.gz
(ssh) chmod +x /opt/scripts/*.sh
(ssh) cd /opt/scripts && ./install.sh
```

# How to run samples on QIRP SDK

The QIRP SDK provides the sample applications that users can run to experience the basic functionality on the device.

## Example 1 - IMU ROS Node

The Qualcomm Sensor See Framework provides the IMU data that is obtained from the IMU driver via DSP. The `qrb_ros_imu` uses this framework to get the latest IMU data with little latency.

**Prerequisite**

- The prebuilt robotics image is flashed.
- SSH is enabled in ‘Permissive’ mode with the steps mentioned in [Use SSH](https://docs.qualcomm.com/bundle/publicresource/topics/80-70017-254/how_to.html?vproduct=1601111740013072&latest=true#use-ssh).

**Set up QIRP SDK and ROS2 environment in each terminal on device**

```bash
ssh root@[ip-addr]
(ssh) export HOME=/opt
(ssh) source /usr/share/qirp-setup.sh
(ssh) export ROS_DOMAIN_ID=xx
(ssh) source /usr/bin/ros_setup.bash
```

**Open terminal 1 and run the IMU ROS Node**

```bash
(ssh) ros2 run qrb_ros_imu imu_node
```

**Open terminal 2 and get the IMU data.**

```bash
(ssh) ros2 topic echo /imu
```

## Example 2 - Orbbec Camera ROS Node

The orbbec-camera ROS node makes the Orbbec camera 335L work properly in RGB or depth mode. It can generate the RGB and depth information by ROS topics.

**Prerequisite**

- The prebuilt robotics image is flashed.
- SSH is enabled in ‘Permissive’ mode with the steps mentioned in [Use SSH](https://docs.qualcomm.com/bundle/publicresource/topics/80-70017-254/how_to.html?vproduct=1601111740013072&latest=true#use-ssh).
- The Orbbec camera 335L is available. For details, see Orbbec Gemini 335L [Product Page](https://www.orbbec.com/products/stereo-vision-camera/gemini-335l/).

**Set up QIRP SDK and ROS2 environment in terminal on device**

```bash
ssh root@[ip-addr]
(ssh) mount -o remount,rw /usr
(ssh) export HOME=/opt
(ssh) source /usr/share/qirp-setup.sh
(ssh) cd /usr/share/orbbec_camera/scripts/
(ssh) bash install_udev_rules.sh
(ssh) udevadm control --reload-rules && udevadm trigger
(ssh) source ../scripts/dds_config.sh
(ssh) ros2 launch orbbec_camera gemini_330_series.launch.py
```


<!--
## Example 2 - Camera ROS Node

With this camera ROS2 node, data can achieve zero-copy performance when coming out of the camera-server. This will greatly reduce the latency between ROS nodes.

The Qualcomm Camera-Server provides camera data that is obtained from the camera sensor. `qrb_ros_camera` uses this camera-server to get the latest camera data. 


**Prerequisite**

- The prebuilt robotics image is flashed.
- SSH is enabled in ‘Permissive’ mode with the steps mentioned in [Use SSH](https://docs.qualcomm.com/bundle/publicresource/topics/80-70017-254/how_to.html?vproduct=1601111740013072&latest=true#use-ssh).


**Set up QIRP SDK and ROS2 environment in each terminal on device**

```bash
ssh root@[ip-addr]
(ssh) export HOME=/opt
(ssh) source /usr/share/qirp-setup.sh
(ssh) export ROS_DOMAIN_ID=xx
(ssh) source /usr/bin/ros_setup.bash
```

**Open terminal 1 and run the CAMERA ROS Node**

```bash
(ssh) ros2 launch qrb_ros_camera qrb_ros_camera_launch.py
```

**Open terminal 2 and get the camera image data.**

```bash
(ssh) ros2 topic echo /image
```
-->

# How to develop application with QIRP SDK

The following example provides a general procedure for developing your first application using the QIRP SDK.

**Prerequisite**

- The prebuilt robotics image is flashed.
- SSH is enabled in ‘Permissive’ mode with the steps mentioned in [Use SSH](https://docs.qualcomm.com/bundle/publicresource/topics/80-70017-254/how_to.html?vproduct=1601111740013072&latest=true#use-ssh).

**Set up the cross-compile environment**

```bash
cd <qirp_decompressed_path>/qirp-sdk
source setup.sh
```

**Fetch the project and develop your own code**


```bash
git clone https://github.com/ros2/demos.git -b jazzy
```

Change the `demos/demo_nodes_cpp/src/topics/talker.cpp` msg data in line46, such as changing 'Hello world' to 'get message success'：

```css
46:msg_->data = "get message success " + std::to_string(count_++);
```

**Compile the application**

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

**Push the application to device**

```bash
cd demos/demo_nodes_cpp/install
tar -czvf demo_nodes_cpp.tar.gz lib share
scp demo_nodes_cpp.tar.gz root@[ip-addr]:/opt/
ssh root@[ip-addr]
(ssh) tar -zxf /opt/demo_nodes_cpp.tar.gz -C /usr/
```

**Run the demo application on the device**

```bash
(ssh) export HOME=/opt
(ssh) source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh
(ssh shell 1) ros2 run demo_nodes_cpp talker
(ssh shell 2) ros2 run demo_nodes_cpp listener
```

# Reference

[Yocto Project Quick Build — The Yocto Project ® 5.0.7 documentation](https://docs.yoctoproject.org/5.0.7/brief-yoctoprojectqs/index.html)

[qcom-manifest/README.md at qcom-linux-scarthgap · qualcomm-linux/qcom-manifest](https://github.com/qualcomm-linux/qcom-manifest/blob/qcom-linux-scarthgap/README.md)
