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

DOCKER_IMAGE_NAME=qirp-docker
ROS_DISTRO=jazzy

DIR=$SDK_TOP_DIR/qirp-samples
config_file="config.yaml"
try_times=5
function download_model(){
    local N=$1
    local sample_dir=$2
    if [ $((N -1)) == 0 ];then
        echo "Fail to download_model $try_times times,  please download from qualcomm ai hub manually"
        return 1
    fi

    if [ ${#model[@]} -ne 0 ]; then
        for smodel in "${model[@]}"; do
            IFS=',' read model_name link <<< $smodel
            if [ -f $sample_dir/model/$model_name.done ]; then
                echo "$model_name has been download in $sample_dir/model"
            else
                wget --no-check-certificate -O $sample_dir/model/$model_name $link
                if [ $? -eq 0 ]; then
                    echo "download $model_name successfully "
                    touch $sample_dir/model/$model_name.done
                else
                    download_model $((N-1)) $sample_dir
                fi
            fi
        done
    fi
}
function download_model_label(){
    local N=$1
    local sample_dir=$2
    if [ $((N -1)) == 0 ];then
        echo "Fail to download_model $try_times times, please download from qualcomm ai hub manually "
        return 1
    fi
    if [ ${#model_label[@]} -ne 0 ]; then
        for smodel in "${model_label[@]}"; do
            IFS=',' read label_name link <<< $smodel
            if [ -f $sample_dir/model/$label_name.done ]; then
                echo "$label_name has been download in $sample_dir/model"
            else
                wget --no-check-certificate -O $sample_dir/model/$label_name $link
                if [ $? -eq 0 ]; then
                    echo "download $label_name successfully "
                    touch $sample_dir/model/$label_name.done
                else
                    download_model_label $((N-1)) $sample_dir
                fi
            fi
        done
    fi
}

function download_ai_model(){
    #check if install yq tool

    if ! command -v yq &> /dev/null; then
        ARCH=$(uname -m)
        if [ "$ARCH" = "x86_64" ]; then
            echo "sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64"
        elif [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
            echo "sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_arm64"
        else
            echo "Unsupported architecture: $ARCH"
            return 1
        fi

        echo "sudo chmod +x /usr/local/bin/yq"
    fi

    #read config file
    conf=$(find "$DIR" -type f -name $config_file)
    for file in $conf; do
        model=()
        model_label=()
        echo "Reading conf file: $file"
        model+=($(yq eval '.model[]' $file))
        model_label+=($(yq eval '.model_label[]' $file))
        sample_dir=$(dirname $(realpath $file))/..
        echo "----------------------------------------"
        echo "need to download model ${model[@]}"
        echo "need to download model_label ${model_label[@]}"
        echo "----------------------------------------"
        if [ ! -d $sample_dir/model ];then
            mkdir $sample_dir/model
        fi
        download_model  $try_times  $sample_dir
        download_model_label $try_times $sample_dir
    done
}

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
    export AMENT_PREFIX_PATH="${OECORE_NATIVE_SYSROOT}/usr:${OECORE_TARGET_SYSROOT}/usr"
    export PYTHONPATH=${OECORE_NATIVE_SYSROOT}/usr/lib/python3.12/site-packages/:${OECORE_TARGET_SYSROOT}/usr/lib/python3.12/site-packages/
    export CMAKE_ARGS="-DPYTHON_EXECUTABLE=${OECORE_NATIVE_SYSROOT}/usr/bin/python3 \
       -DPython3_NumPy_INCLUDE_DIR=${OECORE_NATIVE_SYSROOT}/usr/lib/python3.12/site-packages/numpy/core/include \
       -DCMAKE_MAKE_PROGRAM=/usr/bin/make \
       -DSYSROOT_LIBDIR=${OECORE_TARGET_SYSROOT}/usr/lib \
       -DSYSROOT_INCDIR=${OECORE_TARGET_SYSROOT}/usr/include \
       -DPYTHON_SOABI=cpython-312-aarch64-linux-gnu \
       -DBUILD_TESTING=OFF"

    download_ai_model
    if [[ $? -eq 0 ]]; then
        echo " "
        echo "Setup QIRP Cross Compile Successfully"
    else
        echo "something error. please fix it first"
        return 1
    fi

fi