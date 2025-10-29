# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
# This project is currently under active development
#!/bin/bash
unset DEBUG

while getopts ":d" opt; do
    case $opt in
        d)
            DEBUG=1
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

THIS_SCRIPT=$(readlink -f ${BASH_SOURCE[0]})
scriptdir="$(dirname "${THIS_SCRIPT}")"

cd $scriptdir/..
export AMENT_PREFIX_PATH="${OECORE_NATIVE_SYSROOT}/usr:${OECORE_TARGET_SYSROOT}/usr"
export PYTHONPATH=${PYTHONPATH}:${OECORE_TARGET_SYSROOT}/usr/lib/python3.12/site-packages

if [ -n "$DEBUG" ]; then
  echo "building in debug mode"
  colcon build --merge-install --cmake-args \
    -DPython3_ROOT_DIR=${OECORE_TARGET_SYSROOT}/usr \
    -DPython3_NumPy_INCLUDE_DIR=${OECORE_TARGET_SYSROOT}/usr/lib/python3.12/site-packages/numpy/core/include \
    -DPYTHON_SOABI=cpython-310-aarch64-linux-gnu -DCMAKE_STAGING_PREFIX=$(pwd)/install \
    -DCMAKE_PREFIX_PATH=$(pwd)/install/share \
    -DBUILD_TESTING=OFF \
    -DCMAKE_BUILD_TYPE=Debug
else
  echo "building in normal mode"
  colcon build --merge-install --cmake-args \
    -DPython3_ROOT_DIR=${OECORE_TARGET_SYSROOT}/usr \
    -DPython3_NumPy_INCLUDE_DIR=${OECORE_TARGET_SYSROOT}/usr/lib/python3.12/site-packages/numpy/core/include \
    -DPYTHON_SOABI=cpython-310-aarch64-linux-gnu -DCMAKE_STAGING_PREFIX=$(pwd)/install \
    -DCMAKE_PREFIX_PATH=$(pwd)/install/share \
    -DBUILD_TESTING=OFF
fi