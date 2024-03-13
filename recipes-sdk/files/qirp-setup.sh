#!/bin/bash

# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

SDK_NAME="QIRP_SDK"

export PATH=/opt/qcom/qirf-sdk/usr/bin:${PATH}
export LD_LIBRARY_PATH=/opt/qcom/qirf-sdk/usr/lib:${LD_LIBRARY_PATH}
export AMENT_PREFIX_PATH=/opt/qcom/qirf-sdk/usr:${AMENT_PREFIX_PATH}
