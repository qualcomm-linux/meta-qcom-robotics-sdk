# Welcome to the Qualcomm Intelligent Robotics SDK (QIR SDK)

The [Qualcomm® Intelligent Robotics(QIR) SDK](https://dragonwingdocs.qualcomm.com/SDKs/QIR-SDK-2.0/qualcomm-intelligent-robotics-sdk-documentation) is a collection of components that enable you to develop robotic features on Qualcomm platforms. This SDK is applicable to the Qualcomm Linux releases.

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

## Supported Branches/Tag

| Branches/Tag | Description |
|--------|-------------|
| **main branch** | Primary development branch. Base your contributions here and submit pull requests against it. |
| **wrynose branch** | LTS branch based on Yocto Project 6.0, used by Qualcomm Linux 2.x. |
| **release tag** | Stable release snapshot, see the [tags page](https://github.com/qualcomm-linux/meta-qcom-robotics-sdk/releases). |
| **All stable branches up until styhead** | Stable branches based on previous Yocto Project LTS releases. |

## Usage

QIR SDK is a multi-component project. This guide walks you through building an image that includes `meta-qcom` and `ros-core` content, which can then be flashed to one of the supported devices below.

### Supported Devices

| Hardware | Quick Start Guide | Access |
|----------|-------------------|--------|
| Qualcomm Dragonwing IQ-9075 Evaluation Kit | [Quick Start Guide](https://dragonwingdocs.qualcomm.com/Linux/devices/iq9075-evk/device-overview) | Public |
| Qualcomm Dragonwing IQ-8275 Evaluation Kit | [Quick Start Guide](https://dragonwingdocs.qualcomm.com/Linux/devices/iq8275-evk/device-overview) | Public |

## Getting Started

### Prerequisites

- Please refer to the [Yocto Project Reference Manual](https://docs.yoctoproject.org/ref-manual/system-requirements.html)
to set up your Yocto Project build environment.

- Please follow the instructions below for a KAS-based build. The KAS tool offers
an easy way to setup bitbake based projects. For more details, visit the
[KAS documentation](https://kas.readthedocs.io/en/latest/index.html).
Install kas tool:

    ```bash
    sudo pip3 install kas
    ```
### Quick Build

1. Clone meta-qcom-robotics-sdk layer

    ```bash
    git clone https://github.com/qualcomm-linux/meta-qcom-robotics-sdk -b <Supported Branches/Tag>
    ```

2. Supported kas configurations
         <table>
      <thead>
         <tr>
            <th align="center" valign="top">MACHINE configuration<br /></th>
            <th align="center" valign="top">DISTRO configuration<br /></th>
            <th align="center" valign="top">TARGET image recipe<br /></th>
         </tr>
      </thead>
      <tbody>
         <tr>
            <td align="left">
               <ul>
                  <li><code>iq-8275-evk</code></li>
                  <li><code>iq-9075-evk</code></li>
               </ul>
            </td>
            <td align="left">
               <ul>
                  <li><code>qcom-robotics-distro</code></li>
                  <li><code>qcom-robotics-distro-catchall</code></li>
               </ul>
            </td>
            <td align="left">
               <ul>
                  <li><code>qcom-robotics-image</code></li>
                  <li><code>qcom-robotics-proprietary-image</code></li>
               </ul>
            </td>
         </tr>
      </tbody>
      </table>

  3. Build Command(Example):<**MACHINE**: iq-9075-evk, **DISTRO**: qcom-robotics-distro>

   - To build the robotics image based on open-source components, use the `qcom-robotics-image` target:

     ```bash IQ-9075-EVK
     kas build meta-qcom-robotics-sdk/ci/iq-9075-evk.yml:meta-qcom-robotics-sdk/ci/qcom-robotics-distro.yml:meta-qcom-robotics-sdk/ci/qcom-robotics-image.yml
     ```

   - To build the robotics image with features in the Qualcomm proprietary components, use the `qcom-robotics-proprietary-image` target:

     ```bash IQ-9075-EVK
     kas build meta-qcom-robotics-sdk/ci/iq-9075-evk.yml:meta-qcom-robotics-sdk/ci/qcom-robotics-distro.yml:meta-qcom-robotics-sdk/ci/qcom-robotics-proprietary-image.yml
     ```

For more details, please refer to the [Qualcomm Linux Documentation — Build with GitHub Actions](https://dragonwingdocs.qualcomm.com/SDKs/QIR-SDK-2.0/build-with-git-hub-workflow). 

### Flash the Image

- Please refer to the [Qualcomm Linux Documentation — Flash the Robotics Image](https://dragonwingdocs.qualcomm.com/SDKs/QIR-SDK-2.0/flash-the-robotics-image).

### Use Prebuilt Artifacts

Prebuilt artifacts are available from the
[Qualcomm Linux Documentation — Download Prebuilt Packages](https://dragonwingdocs.qualcomm.com/SDKs/QIR-SDK-2.0/download-the-prebuilt-packages).

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