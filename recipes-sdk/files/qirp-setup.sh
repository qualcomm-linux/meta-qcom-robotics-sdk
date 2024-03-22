#!/bin/bash

# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

SDK_NAME="QIRP_SDK"

#common environment variables export
export PATH=/opt/qcom/qirp-sdk/bin/aarch64-oe-linux-gcc11.2:/opt/qcom/qirp-sdk/usr/bin:${PATH}
export LD_LIBRARY_PATH=/opt/qcom/qirp-sdk/lib/aarch64-oe-linux-gcc11.2:/opt/qcom/qirp-sdk/usr/lib:/opt/qcom/qirp-sdk/lib:${LD_LIBRARY_PATH}

#ROS environment variables export
export AMENT_PREFIX_PATH=/opt/qcom/qirp-sdk/usr:${AMENT_PREFIX_PATH}
export PYTHONPATH=/opt/qcom/qirp-sdk/usr/lib/python3.10/site-packages:${PYTHONPATH}

#gst environment variables export
export GST_PLUGIN_PATH=/opt/qcom/qirp-sdk/usr/lib/gstreamer-1.0:${GST_PLUGIN_PATH}
export GST_PLUGIN_SCANNER=/opt/qcom/qirp-sdk/usr/libexec/gstreamer-1.0/gst-plugin-scanner:${GST_PLUGIN_SCANNER}

#qnn environment variables export
export ADSP_LIBRARY_PATH=/opt/qcom/qirp-sdk/lib/aarch64-oe-linux-gcc11.2:${ADSP_LIBRARY_PATH}
