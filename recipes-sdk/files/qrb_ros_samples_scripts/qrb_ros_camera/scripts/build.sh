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
export PYTHONPATH=${OECORE_NATIVE_SYSROOT}/usr/lib/python3.12/site-packages/:${OECORE_TARGET_SYSROOT}/usr/lib/python3.12/site-packages/

if [ -n "$DEBUG" ]; then
  echo "building in debug mode"
  colcon build --continue-on-error --cmake-args \
    -DCMAKE_TOOLCHAIN_FILE=${OE_CMAKE_TOOLCHAIN_FILE} \
    -DPYTHON_EXECUTABLE=${OECORE_NATIVE_SYSROOT}/usr/bin/python3 \
    -DPython3_NumPy_INCLUDE_DIR=${OECORE_NATIVE_SYSROOT}/usr/lib/python3.12/site-packages/numpy/core/include \
    -DSYSROOT_LIBDIR=${OECORE_TARGET_SYSROOT}/usr/lib \
    -DSYSROOT_INCDIR=${OECORE_TARGET_SYSROOT}/usr/include \
    -DCMAKE_MAKE_PROGRAM=/usr/bin/make \
    -DBUILD_TESTING=OFF \
    -DCMAKE_BUILD_TYPE=Debug
else
  echo "building in normal mode"
  colcon build --continue-on-error --cmake-args \
    -DCMAKE_TOOLCHAIN_FILE=${OE_CMAKE_TOOLCHAIN_FILE} \
    -DPYTHON_EXECUTABLE=${OECORE_NATIVE_SYSROOT}/usr/bin/python3 \
    -DPython3_NumPy_INCLUDE_DIR=${OECORE_NATIVE_SYSROOT}/usr/lib/python3.12/site-packages/numpy/core/include \
    -DSYSROOT_LIBDIR=${OECORE_TARGET_SYSROOT}/usr/lib \
    -DSYSROOT_INCDIR=${OECORE_TARGET_SYSROOT}/usr/include \
    -DCMAKE_MAKE_PROGRAM=/usr/bin/make \
    -DBUILD_TESTING=OFF
fi