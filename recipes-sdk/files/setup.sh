# Copyright (c) 2023-2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

#!/bin/bash

THIS_SCRIPT=$(readlink -f ${BASH_SOURCE[0]})
scriptdir="$(dirname "${THIS_SCRIPT}")"
export SDK_TOP_DIR=$scriptdir
cd $SDK_TOP_DIR

#create toolchain dir
if [ ! -d "$SDK_TOP_DIR/toolchain/install_dir" ];then
  # Install toolchain
  search_dir="toolchain"
  for file in $search_dir/*.sh; do
    echo $file
    mkdir toolchain/install_dir
    ./"$file" -d $SDK_TOP_DIR/toolchain/install_dir -y
  done

  export search_dir=$SDK_TOP_DIR/toolchain/install_dir/environment*linux
  for file in $search_dir;do
    . "$file"
  done

  #unpack qirp-sdk tarball into runtime/qirp-sdk
  search_dir="runtime"
  cd $search_dir
  mkdir -p qirp-sdk
  for file in *tar.gz; do
    echo $file
    tar -zxvf "$file" -C qirp-sdk
  done

  #install runtime/packages qirp packages
  pkgs=$(ls $SDK_TOP_DIR/runtime/qirp-sdk/packages/*ipk)
  if [ ! -d "$SDK_TOP_DIR/runtime/qirp-sdk/tmp-dir" ]; then
        mkdir $SDK_TOP_DIR/runtime/qirp-sdk/tmp-dir
  fi
  if [ ! -d "$SDK_TOP_DIR/runtime/qirp-sdk/install-dir" ]; then
        mkdir $SDK_TOP_DIR/runtime/qirp-sdk/install-dir
  fi
  cd $SDK_TOP_DIR/runtime/qirp-sdk/tmp-dir
  for pkg in $pkgs; do
    echo "install pkg $pkg ...   "
    ar -x $pkg
    xz -d data.tar.xz && tar -xf data.tar -C $SDK_TOP_DIR/runtime/qirp-sdk/install-dir
    rm -rf $SDK_TOP_DIR/runtime/qirp-sdk/tmp-dir/*
  done

  rsync -av $SDK_TOP_DIR/runtime/qirp-sdk/install-dir/ $SDK_TOP_DIR/toolchain/install_dir/sysroots/armv8-2a-qcom-linux/
  # comment this line due to qirp-sdk install path change from opt/qcom/qirp-sdk to /
  #rsync $SDK_TOP_DIR/toolchain/install_dir/sysroots/armv8-2a-qcom-linux/opt/qcom/qirp-sdk/* $SDK_TOP_DIR/toolchain/install_dir/sysroots/armv8-2a-qcom-linux/
  cd $SDK_TOP_DIR
fi

#install or uninstall qirp
if [ "$1" == "uninstall" ]; then
  if [ -d "toolchain/install_dir" ]; then
    rm -rf toolchain/install_dir
    rm -rf runtime/qirp*/*
  fi
  echo "uninstall qirp sdk "
else
  #run sdk env setup
  export search_dir=$SDK_TOP_DIR/toolchain/install_dir/environment*linux
  for file in $search_dir;do
    . "$file"
  done

  if [ -d "$SDKTARGETSYSROOT" ]; then
    ln -sf $SDKTARGETSYSROOT/usr/src/debug/camxlib-kt/1.0-r0/vendor/qcom/proprietary/camx-api-kt/camx/service/system $SDKTARGETSYSROOT/usr/include/system
  fi
  echo "setup qirp sysroot done!"
fi
