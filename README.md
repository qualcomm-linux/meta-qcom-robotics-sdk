# Welcome to the Qualcomm Intelligent Robotics Product SDK (QIRP SDK)

The Qualcomm® Intelligent Robotics Product (QIRP) SDK is a collection of components that enable you to develop robotic features on Qualcomm platforms. This SDK is applicable to the Qualcomm Linux releases.

The QIRP SDK provides the following:
- Reference code in Robot Operating System (ROS) packages to develop robotic applications.
- E2E(end-to-end) scenario samples to evaluate robotic platforms.
- Integrated cross-compile toolchain, which includes common build tools, such as aarch64-oe-linux-gcc, make, cmake, and ROS core.
- Tools and scripts to speed up the development.
- Provide some basic ROS nodes to help you build your ros application, such as qrb_ros_camera, qrb_ros_nn_inference,etc.

This will guide you through developing your first sample application. It explains how to:
- Flash the prebuilt Qualcomm linux image and configure the environment.
- Run sample applications.
- Develop sample applications using the prebuilt image and QIRP SDK.
- Generate customized images and QIRP SDK.
- Provides a Gazebo simulation environment for testing and debugging robotic applications.

This repository serves as a ​​layer in the QIRP SDK build system​​, working in conjunction with other layers such as:
- [meta-qcom-robotics-distro](https://github.com/qualcomm-linux/meta-qcom-robotics-distro.git) 
- [meta-qcom-robotics](https://github.com/qualcomm-linux/meta-qcom-robotics.git) 

to collectively build the **QIRP SDK**.

## Branches

**scarthgap**: Primary development branch. Contributors should develop submissions based on this branch, and submit pull requests to this branch.

## Usage

As part of QIRP, this project requires ​​collaborative usage with other components​​. Detailed instructions are provided in:
- [QIRP SDK User Guide](https://docs.qualcomm.com/bundle/publicresource/topics/80-70018-265/introduction_1.html?vproduct=1601111740013072&version=1.4&facet=Qualcomm%20Intelligent%20Robotics%20Product%20(QIRP)%20SDK)

## Development

How to develop new features/fixes for the software. Maybe different than "usage". Also provide details on how to contribute via a [CONTRIBUTING.md](CONTRIBUTING.md).

## Getting in Contact

How to contact maintainers. E.g. GitHub Issues, GitHub Discussions could be indicated for many cases. However a mail list or list of Maintainer e-mails could be shared for other types of discussions. 

* [Report an Issue on GitHub](../../issues)
* [Open a Discussion on GitHub](../../discussions)
* E-mail
  * dapeyuan@qti.qualcomm.com
  * jialchen@qti.qualcomm.com
  * huiyqiu@qti.qualcomm.com


## License

*meta-qcom-robotics-sdk* is licensed under the [BSD-3-clause License](https://spdx.org/licenses/BSD-3-Clause.html). See [LICENSE.txt](LICENSE.txt) for the full license text.
