# Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

#!/bin/bash

THIS_SCRIPT=$(readlink -f ${BASH_SOURCE[0]})
scriptdir="$(dirname "${THIS_SCRIPT}")"
export SDK_TOP_DIR=$scriptdir
cd $SDK_TOP_DIR

#create toolchain dir
if [ ! -d "$SDK_TOP_DIR/toolchain/install_dir" ];then
    #check dependencys
    if ! command -v zstd &> /dev/null
    then
        echo "zstd command not found ! please install it first"
        return
    fi
    #Install toolchain
    search_dir="toolchain"
    mkdir toolchain/install_dir
    for file in $search_dir/*.sh; do
        echo $file
        ./"$file" -d $SDK_TOP_DIR/toolchain/install_dir -y
    done

    export search_dir=$SDK_TOP_DIR/toolchain/install_dir/environment*linux
    for file in $search_dir;do
        echo $file
        . "$file"
    done

    #unpack qirp-sdk tarball into runtime/qirp-sdk
    search_dir="runtime"
    cd $search_dir
    if [ ! -d "qirp-sdk " ];then
        mkdir -p qirp-sdk
    fi
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
        tar -I zstd -xvf data.tar.zst -C $SDK_TOP_DIR/runtime/qirp-sdk/install-dir
        rm -rf $SDK_TOP_DIR/runtime/qirp-sdk/tmp-dir/*
    done

    rsync -av $SDK_TOP_DIR/runtime/qirp-sdk/install-dir/ $SDK_TOP_DIR/toolchain/install_dir/sysroots/armv8-2a-qcom-linux/
    # comment this line due to qirp-sdk install path change from opt/qcom/qirp-sdk to /
    #rsync $SDK_TOP_DIR/toolchain/install_dir/sysroots/armv8-2a-qcom-linux/opt/qcom/qirp-sdk/* $SDK_TOP_DIR/toolchain/install_dir/sysroots/armv8-2a-qcom-linux/
    cd $SDK_TOP_DIR

    if [ -d "$SDKTARGETSYSROOT" ]; then
        QIRP_TEMP_LN_PATH=$(find $SDKTARGETSYSROOT -type f -name "camera_metadata.h" -exec dirname {} \;)
        if [ -n "$QIRP_TEMP_LN_PATH" ]; then
            ln -sf $QIRP_TEMP_LN_PATH $SDKTARGETSYSROOT/usr/include/system
        fi
    fi
    echo "setup qirp sysroot done!"
fi

DOCKER_IMAGE_NAME=qirp_docker
ROS_DISTRO=jazz
CONTAINER_NAME=qirp_docker_container_host
#CONTAINER_NAME=qirp_docker_container

function build_docker_image(){
    #check depends
    if ! command -v docker &> /dev/null
    then
        echo "docker command not found ! please install it first"
        return
    fi
    # Check if Docker image exists
    if ! docker images | grep -q "$DOCKER_IMAGE_NAME"; then
        echo "Docker image $DOCKER_IMAGE_NAME not found, loading..."
        docker pull --platform=linux/arm64/v8 ros:$ROS_DISTRO
        if [ $? -eq 0 ]; then
            echo "Docker image successfully loaded."
        else
            echo "Error loading Docker image."
            exit 1
        fi
        docker tag ros:$ROS_DISTRO qirp_docker:latest
    else
        echo "Docker image $DOCKER_IMAGE_NAME already exists."
    fi

    # Check if Docker container exists
    if ! docker ps -a | grep -q "$CONTAINER_NAME"; then
        echo "Docker container $CONTAINER_NAME not found, starting..."
        docker run -d -it \
            -e LOCAL_USER_NAME=$(whoami) \
            -e LOCAL_USER_ID=$(id | awk -F "(" '{print $1}' | sed 's/uid=//') \
            -e LOCAL_GROUP_ID=$(id | awk -F "(" '{print $2}' | awk -F " " '{print $NF}' | sed 's/gid=//') \
            --name=$CONTAINER_NAME \
            --security-opt seccomp=unconfined \
            $DOCKER_IMAGE_NAME:latest /bin/bash
        if [ $? -eq 0 ]; then
            echo "Docker container successfully started."
        else
            echo "Error starting Docker container."
            exit 1
        fi
    else
        echo "Docker container $CONTAINER_NAME already exists."
    fi
    DOCKER_SCRIPTS=$(find $SDK_TOP_DIR/runtime/qirp-sdk/install-dir -name "qirp-setup.sh")

    docker cp $DOCKER_SCRIPTS $CONTAINER_NAME:/home
    #docker exec $CONTAINER_NAME /bin/bash -c "sed -i '/curl -sSL/,+2d' /home/qirp-setup.sh "
    docker exec $CONTAINER_NAME /bin/bash /home/qirp-setup.sh
    docker commit $CONTAINER_NAME $DOCKER_IMAGE_NAME
    docker save $DOCKER_IMAGE_NAME | gzip > $SDK_TOP_DIR/runtime/qirp_docker.tar.gz
}



#install or uninstall qirp
if [ "$1" == "uninstall" ]; then
    if [ -d "toolchain/install_dir" ]; then
        rm -rf toolchain/install_dir
        rm -rf runtime/qirp*/*
    fi
    echo "uninstall qirp sdk "

elif [ "$1" == "docker" ];then
    echo "building docker image..."
    build_docker_image
else
    #run sdk env setup
    export search_dir=$SDK_TOP_DIR/toolchain/install_dir/environment*linux
    for file in $search_dir;do
        . "$file"
    done
    export AMENT_PREFIX_PATH="${OECORE_NATIVE_SYSROOT}/usr:${OECORE_TARGET_SYSROOT}/usr"
    export PYTHONPATH=${OECORE_NATIVE_SYSROOT}/usr/lib/python3.12/site-packages/:${OECORE_TARGET_SYSROOT}/usr/lib/python3.12/site-packages/
fi
