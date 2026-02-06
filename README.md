# Welcome to the Qualcomm Intelligent Robotics SDK (QIR SDK)

The Qualcomm® Intelligent Robotics(QIR) SDK is a collection of components that enable you to develop robotic features on Qualcomm platforms. This SDK is applicable to the Qualcomm Linux releases.

The QIR SDK provides the following:
- Reference code in Robot Operating System (ROS) packages to develop robotic applications.
- E2E(end-to-end) scenario samples to evaluate robotic platforms.
- Integrated cross-compile toolchain, which includes common build tools, such as aarch64-oe-linux-gcc, make, cmake, and ROS core.
- Tools and scripts to speed up the development.
- Provide some basic ROS nodes to help you build your ros application, such as qrb_ros_camera, qrb_ros_nn_inference, etc.

This will guide you through developing your first sample application. It explains how to:
- Flash the prebuilt Qualcomm linux image and configure the environment.
- Run sample applications.
- Develop sample applications using the prebuilt image and QIR SDK.
- Generate customized images and QIR SDK.
- Provide a Gazebo simulation environment for testing and debugging robotic applications.

## Branches

**main**: Primary development branch. Contributors should develop submissions based on this branch, and submit pull requests to this branch.

## Usage

As part of QIR, this project requires collaborative usage with other components. Detailed sample content will be provided in the future.

Here, we provide some compile or develop commands to help develop more efficiently.

After following this guide, you will compile an image that includes meta-qcom and ros-core content.
And you can flash the image to the following devices to start your work.

| Hardware                                               | Document                                                     | Access level |
| ------------------------------------------------------ | ------------------------------------------------------------ | ------------ |
| Qualcomm DragonwingTM RB3 Gen 2 Vision Development Kit | [Quick Start Guide](https://docs.qualcomm.com/bundle/publicresource/topics/80-70022-253) | Public       |
| Qualcomm DragonwingTM IQ-9075 Evaluation Kit           | [Quick Start Guide](https://docs.qualcomm.com/bundle/publicresource/topics/80-70022-263) | Public       |
| Qualcomm® IQ-8 Beta Evaluation Kit                     | [Quick Start Guide](https://docs.qualcomm.com/bundle/80-70017-263/resource/80-70017-263.pdf) | Authorized   |

Here are the detailed steps:

1. Please refer to the [Yocto Project Reference Manual](https://docs.yoctoproject.org/ref-manual/system-requirements.html) to set up your Yocto Project build environment.

2. Please follow the instructions below for a KAS-based build. The KAS tool offers an easy way to setup bitbake based projects. For more details, visit the [KAS documentation](https://kas.readthedocs.io/en/latest/index.html).

3. Install kas tool

   ```
   sudo pip3 install kas
   ```

4. Clone meta-qcom-robotics-sdk layer

   ```
   git clone https://github.com/qualcomm-linux/meta-qcom-robotics-sdk.git -b main
   ```

5. Build using the KAS configuration for one of the supported boards

   ```
   kas build meta-qcom-robotics-sdk/ci/<YOUR MACHINE NAME>.yml:meta-qcom-robotics-sdk/ci/<DISTRO NAME>.yml

   # For example, to build for Qualcomm DragonwingTM IQ-9075 Evaluation Kit using robotics distro property image, run the following command:
   kas build meta-qcom-robotics-sdk/ci/iq-9075-evk.yml:meta-qcom-robotics-sdk/ci/qcom-robotics-distro-prop-image.yml
   ```
   Supported machines and distributions are listed below:
   | Machine Names | Target Names |
   | ------------ | ------------ |
   | iq-8275-evk | qcom-robotics-distro, qcom-robotics-distro-prop-image |
   | iq-9075-evk | qcom-robotics-distro, qcom-robotics-distro-prop-image |

6. The output image will be located in the follow path:

   ```
   build/tmp/deploy/images/<YOUR MACHINE NAME>/*.rootfs.qcomflash
   ```

7. Please refer to the [Flash steps](https://github.com/qualcomm-linux/meta-qcom) to flash the image to the target device using the QDL tools.

## Development

How to develop new features/fixes for the software. Maybe different than "usage". Also provide details on how to contribute via a [CONTRIBUTING.md](CONTRIBUTING.md).

## Getting in Contact

How to contact maintainers. E.g. GitHub Issues, GitHub Discussions could be indicated for many cases. However, a mail list or list of Maintainer e-mails could be shared for other types of discussions.

* [Report an Issue on GitHub](../../issues)
* E-mail
    * dapeyuan@qti.qualcomm.com
    * fulaliu@qti.qualcomm.com
    * huiyqiu@qti.qualcomm.com

## License

**meta-qcom-robotics-sdk** is licensed under the [BSD-3-clause License](https://spdx.org/licenses/BSD-3-Clause.html). See [LICENSE.txt](LICENSE.txt) for the full license text.