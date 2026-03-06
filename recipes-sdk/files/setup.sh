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
    missing_tools=""
    for tool in zstd rpm2cpio cpio; do
        if ! command -v $tool &> /dev/null; then
            missing_tools="$missing_tools $tool"
        fi
    done

    if [ -n "$missing_tools" ]; then
        echo "The following required tools are missing:$missing_tools"
        echo "Please install them first."
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
    ipk_pkgs=$(ls $SDK_TOP_DIR/runtime/qirp-sdk/packages/*.ipk 2>/dev/null)
    rpm_pkgs=$(ls $SDK_TOP_DIR/runtime/qirp-sdk/packages/*.rpm 2>/dev/null)

    if [ ! -d "$SDK_TOP_DIR/runtime/qirp-sdk/tmp-dir" ]; then
        mkdir $SDK_TOP_DIR/runtime/qirp-sdk/tmp-dir
    fi
    if [ ! -d "$SDK_TOP_DIR/runtime/qirp-sdk/install-dir" ]; then
        mkdir $SDK_TOP_DIR/runtime/qirp-sdk/install-dir
    fi

    cd $SDK_TOP_DIR/runtime/qirp-sdk/tmp-dir

    # install ipk packages
    for pkg in $ipk_pkgs; do
        echo "install ipk pkg $pkg ...   "
        ar -x $pkg
        tar -I zstd -xvf data.tar.zst -C $SDK_TOP_DIR/runtime/qirp-sdk/install-dir
        rm -rf $SDK_TOP_DIR/runtime/qirp-sdk/tmp-dir/*
    done

   # install rpm packages
    for pkg in $rpm_pkgs; do
        echo "install rpm pkg $pkg ...   "
        rpm2cpio $pkg | cpio -idmv -D $SDK_TOP_DIR/runtime/qirp-sdk/install-dir
    done


    rsync -av $SDK_TOP_DIR/runtime/qirp-sdk/install-dir/ $SDK_TOP_DIR/toolchain/install_dir/sysroots/armv8-2a-qcom-linux/
    # comment this line due to qirp-sdk install path change from opt/qcom/qirp-sdk to /
    #rsync $SDK_TOP_DIR/toolchain/install_dir/sysroots/armv8-2a-qcom-linux/opt/qcom/qirp-sdk/* $SDK_TOP_DIR/toolchain/install_dir/sysroots/armv8-2a-qcom-linux/
    cd $SDK_TOP_DIR

    if [ -d "$SDKTARGETSYSROOT" ]; then
        camera_metadata_file=$(find "$SDKTARGETSYSROOT" -type f -name "camera_metadata.h" -print -quit)
        if [ -n "$camera_metadata_file" ]; then
            QIRP_TEMP_LN_PATH=$(dirname "$camera_metadata_file")
            mkdir -p "$SDKTARGETSYSROOT/usr/include"
            ln -sf "$QIRP_TEMP_LN_PATH" "$SDKTARGETSYSROOT/usr/include/system"
         fi
     fi

     echo "setup qirp sysroot done!"

fi

DOCKER_IMAGE_NAME=qirp-docker
ROS_DISTRO=jazzy
CONTAINER_NAME=qirp_docker_container_host
#CONTAINER_NAME=qirp_docker_container

function build_docker_image(){
    #check depends
    if ! command -v docker &> /dev/null
    then
        echo "docker command not found ! please install it first"
        return 1
    fi
    # Check if Docker image exists
    if ! docker images --format "{{.Repository}}" | grep -w ^$DOCKER_IMAGE_NAME$;then
        echo "Docker image $DOCKER_IMAGE_NAME not found, loading..."
        docker pull --platform linux/arm64/v8 docker-registry.qualcomm.com/fulaliu/arm64v8/ros:jazzy-ros-base
        #docker pull --platform linux/arm64/v8 arm64v8/ros:$ROS_DISTRO-ros-base
        if [ $? -eq 0 ]; then
            echo "Docker image successfully loaded."
        else
            echo "Error loading Docker image."
            return 1
        fi
        docker tag docker-registry.qualcomm.com/fulaliu/arm64v8/ros:jazzy-ros-base $DOCKER_IMAGE_NAME:latest
    else
        echo "Docker image $DOCKER_IMAGE_NAME already exists."
    fi


    # Check if Docker container exists
    if !  docker ps -a --format "{{.Names}}" | grep -w ^$CONTAINER_NAME$; then
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
            return 1
        fi
    else
        echo "Docker container $CONTAINER_NAME already exists."
    fi
    DOCKER_SCRIPTS=$(find $SDK_TOP_DIR/runtime/qirp-sdk/install-dir -name "qirp-setup.sh")

    docker cp $DOCKER_SCRIPTS $CONTAINER_NAME:/home
    #docker exec $CONTAINER_NAME /bin/bash -c "sed -i '/curl -sSL/,+8d' /home/qirp-setup.sh "
    docker exec $CONTAINER_NAME /bin/bash /home/qirp-setup.sh
    docker commit $CONTAINER_NAME $DOCKER_IMAGE_NAME
    docker save $DOCKER_IMAGE_NAME | gzip > $SDK_TOP_DIR/runtime/$DOCKER_IMAGE_NAME.tar.gz
}
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

setup_qirp_ros_env() {
  # Select the Python interpreter used to detect the version.
  # Prefer the SDK native Python if available; otherwise fall back to system python3.
  local PY="${OECORE_NATIVE_SYSROOT}/usr/bin/python3"
  if [ ! -x "${PY}" ]; then
    PY="$(command -v python3)"
  fi

  # Extract major.minor version (e.g., "3.14" or "3.12").
  local PY_VER
  PY_VER="$("${PY}" -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' 2>/dev/null)" || {
    echo "[ERROR] Failed to run python to detect version: ${PY}"
    return 1
  }

  case "${PY_VER}" in
    3.14)
      # Set up AMENT prefix paths for both native and target sysroots.
      export AMENT_PREFIX_PATH="${OECORE_NATIVE_SYSROOT}/usr/ros/jazzy:${OECORE_TARGET_SYSROOT}/usr/ros/jazzy:${OECORE_NATIVE_SYSROOT}/usr:${OECORE_TARGET_SYSROOT}/usr"

      # Set PYTHONPATH for both native and target site-packages and ROS Jazzy python packages.
      # Note: Avoid empty path entries (e.g., double colons "::") to prevent accidental imports.
      export PYTHONPATH="${OECORE_TARGET_SYSROOT}/usr/ros/jazzy/lib/python3.14/site-packages:${OECORE_NATIVE_SYSROOT}/usr/ros/jazzy/lib/python3.14/site-packages"

      # Prefer NumPy 2.x layout: numpy/_core/include. Fall back to numpy/core/include if needed.
      local NUMPY_INC_314="${OECORE_NATIVE_SYSROOT}/usr/lib/python3.14/site-packages/numpy/_core/include"
      if [ ! -d "${NUMPY_INC_314}" ]; then
        NUMPY_INC_314="${OECORE_NATIVE_SYSROOT}/usr/lib/python3.14/site-packages/numpy/core/include"
      fi

      # CMake arguments used by colcon build.
      export CMAKE_ARGS="-DPYTHON_EXECUTABLE=${OECORE_NATIVE_SYSROOT}/usr/bin/python3 \
       -DPython3_NumPy_INCLUDE_DIR=${NUMPY_INC_314} \
       -DCMAKE_MAKE_PROGRAM=/usr/bin/make \
       -DSYSROOT_LIBDIR=${OECORE_TARGET_SYSROOT}/usr/lib \
       -DSYSROOT_INCDIR=${OECORE_TARGET_SYSROOT}/usr/include \
       -DPYTHON_SOABI=cpython-312-aarch64-linux-gnu \
       -DBUILD_TESTING=OFF"
      ;;

    3.12)
      # Set up AMENT prefix paths for ROS Jazzy in native and target sysroots.
      export AMENT_PREFIX_PATH="${OECORE_NATIVE_SYSROOT}/usr/ros/jazzy:${OECORE_TARGET_SYSROOT}/usr/ros/jazzy"

      # Set PYTHONPATH for both native and target site-packages.
      export PYTHONPATH="${OECORE_NATIVE_SYSROOT}/usr/lib/python3.12/site-packages/:${OECORE_TARGET_SYSROOT}/usr/lib/python3.12/site-packages/"

      # Prefer traditional NumPy layout: numpy/core/include. Fall back to numpy/_core/include if needed.
      local NUMPY_INC_312="${OECORE_NATIVE_SYSROOT}/usr/lib/python3.12/site-packages/numpy/core/include"
      if [ ! -d "${NUMPY_INC_312}" ]; then
        NUMPY_INC_312="${OECORE_NATIVE_SYSROOT}/usr/lib/python3.12/site-packages/numpy/_core/include"
      fi

      # CMake arguments used by colcon build.
      export CMAKE_ARGS="-DPYTHON_EXECUTABLE=${OECORE_NATIVE_SYSROOT}/usr/bin/python3 \
       -DPython3_NumPy_INCLUDE_DIR=${NUMPY_INC_312} \
       -DCMAKE_MAKE_PROGRAM=/usr/bin/make \
       -DSYSROOT_LIBDIR=${OECORE_TARGET_SYSROOT}/usr/lib \
       -DSYSROOT_INCDIR=${OECORE_TARGET_SYSROOT}/usr/include \
       -DPYTHON_SOABI=cpython-312-aarch64-linux-gnu \
       -DBUILD_TESTING=OFF"
      ;;

    *)
      # Unsupported Python version.
      echo "[ERROR] Unsupported Python version: ${PY_VER}. Only 3.14 and 3.12 are supported."
      return 1
      ;;
  esac

  # Optional: Print key environment variables for quick verification.
  echo "[INFO] Python version = ${PY_VER}"
  echo "[INFO] AMENT_PREFIX_PATH = ${AMENT_PREFIX_PATH}"
  echo "[INFO] PYTHONPATH = ${PYTHONPATH}"
  echo "[INFO] CMAKE_ARGS = ${CMAKE_ARGS}"
  return 0
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
  # Select the Python interpreter used to detect the version.
  # Prefer the SDK native Python if available; otherwise fall back to system python3.
    setup_qirp_ros_env
    download_ai_model
    if [[ $? -eq 0 ]]; then
        echo " "
        echo "Setup QIRP Cross Compile Successfully"
    else
        echo "something error. please fix it first"
        return 1
    fi

fi

if [ "$1" == "docker" ];then
    echo "building docker image..."
    build_docker_image
    if [[ $? -eq 0 ]]; then
        echo " "
        echo "building docker image Successfully"
    else
        echo "something error. please fix it first"
        return 1
    fi
fi
