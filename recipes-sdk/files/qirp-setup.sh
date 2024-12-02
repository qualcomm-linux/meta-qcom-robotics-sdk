#!/bin/bash

# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

SDK_NAME="QIRP_SDK"

#common environment variables export
export PATH=/bin/aarch64-oe-linux-gcc11.2:/usr/bin:/usr/bin/qim/:${PATH}
export LD_LIBRARY_PATH=/lib/aarch64-oe-linux-gcc11.2:/usr/lib:/usr/lib/qim:/lib:${LD_LIBRARY_PATH}

#ROS environment variables export
export AMENT_PREFIX_PATH=/usr:${AMENT_PREFIX_PATH}
export PYTHONPATH=/usr/lib/python3.10/site-packages:${PYTHONPATH}

#gst environment variables export
export GST_PLUGIN_PATH=/usr/lib/qim/gstreamer-1.0:/usr/lib/gstreamer-1.0:${GST_PLUGIN_PATH}
export GST_PLUGIN_SCANNER=/usr/libexec/qim/gstreamer-1.0/gst-plugin-scanner:/usr/libexec/gstreamer-1.0/gst-plugin-scanner:${GST_PLUGIN_SCANNER}

#qnn environment variables export
export ADSP_LIBRARY_PATH=/lib/aarch64-oe-linux-gcc11.2:/lib/hexagon-v68/unsigned:${ADSP_LIBRARY_PATH}


# if (target:ubuntu):
#     apt install <toolchain list>
