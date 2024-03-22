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

  #tar -zxvf qirp tar.gz
  search_dir="runtime"
  cd $search_dir
  for file in *tar.gz; do
    echo $file
    tar -zxvf "$file"
  done

  #install qirp packages
  for file in qirp*; do
    echo $file
    if [ -d "$file" ]; then
      cd $file
      ar -x qirp-*.ipk
      xz -d data.tar.xz && tar -xf data.tar
      cd ../
    fi
  done
  cd $SDK_TOP_DIR/runtime/qirp-sdk
  rsync -av opt/qcom/qirp-sdk/ $SDK_TOP_DIR/toolchain/install_dir/sysroots/armv8-2a-qcom-linux/
  rm opt control.tar.gz data.tar debian-binary -rf
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

  # get work on which sp by MACHIE_DISTRO
  DISTRO=$(cat $SDKTARGETSYSROOT/../../version-*-linux | grep -oP '(?<=Distro: )\S+')
  MACHINE=$(cat $SDKTARGETSYSROOT/etc/hostname)
  export MACHINE_DISTRO=$MACHINE'_'$DISTRO
  #echo $MACHINE_DISTRO
  #echo $SDKTARGETSYSROOT/usr/include/platform_config.h
  #echo $SDK_TOP_DIR/sample-code/Product_SDK_Samples/Applications/platform_config.h
  if [ ! -h $SDKTARGETSYSROOT/usr/include/platform_config.h ]; then
    ln -sf $SDK_TOP_DIR/sample-code/Product_SDK_Samples/Applications/platform_config.h $SDKTARGETSYSROOT/usr/include/platform_config.h
  fi
  echo "setup qirp sysroot done!"
fi
