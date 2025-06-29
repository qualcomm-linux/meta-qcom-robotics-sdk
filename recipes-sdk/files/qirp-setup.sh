#/bin/bash

# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
# current dir

HOST_FILES=()

HOST_LIB_PATH="/usr/lib"
HOST_INCLUDE_PATH="/usr/include"
CONTAINER_LIB_PATH="/usr/local/lib"
CONTAINER_INCLUDE_PATH="/usr/local/include"

# libs and head flies of QNN SDK
HOST_FILES+=("-v /usr/bin/qtld-net-run:/usr/bin/qtld-net-run")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libcalculator.so:${CONTAINER_LIB_PATH}/libcalculator.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libhta_hexagon_runtime_snpe.so:${CONTAINER_LIB_PATH}/libhta_hexagon_runtime_snpe.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libPlatformValidatorShared.so:${CONTAINER_LIB_PATH}/libPlatformValidatorShared.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnChrometraceProfilingReader.so:${CONTAINER_LIB_PATH}/libQnnChrometraceProfilingReader.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnCpu.so:${CONTAINER_LIB_PATH}/libQnnCpu.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnDsp.so:${CONTAINER_LIB_PATH}/libQnnDsp.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnDspNetRunExtensions.so:${CONTAINER_LIB_PATH}/libQnnDspNetRunExtensions.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnDspV66CalculatorStub.so:${CONTAINER_LIB_PATH}/libQnnDspV66CalculatorStub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnDspV66Stub.so:${CONTAINER_LIB_PATH}/libQnnDspV66Stub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnGenAiTransformer.so:${CONTAINER_LIB_PATH}/libQnnGenAiTransformer.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnGenAiTransformerCpuOpPkg.so:${CONTAINER_LIB_PATH}/libQnnGenAiTransformerCpuOpPkg.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnGenAiTransformerModel.so:${CONTAINER_LIB_PATH}/libQnnGenAiTransformerModel.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnGpu.so:${CONTAINER_LIB_PATH}/libQnnGpu.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnGpuNetRunExtensions.so:${CONTAINER_LIB_PATH}/libQnnGpuNetRunExtensions.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnGpuProfilingReader.so:${CONTAINER_LIB_PATH}/libQnnGpuProfilingReader.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnHtp.so:${CONTAINER_LIB_PATH}/libQnnHtp.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnHtpNetRunExtensions.so:${CONTAINER_LIB_PATH}/libQnnHtpNetRunExtensions.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnHtpOptraceProfilingReader.so:${CONTAINER_LIB_PATH}/libQnnHtpOptraceProfilingReader.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnHtpPrepare.so:${CONTAINER_LIB_PATH}/libQnnHtpPrepare.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnHtpProfilingReader.so:${CONTAINER_LIB_PATH}/libQnnHtpProfilingReader.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnHtpV68CalculatorStub.so:${CONTAINER_LIB_PATH}/libQnnHtpV68CalculatorStub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnHtpV68Stub.so:${CONTAINER_LIB_PATH}/libQnnHtpV68Stub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnHtpV69CalculatorStub.so:${CONTAINER_LIB_PATH}/libQnnHtpV69CalculatorStub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnHtpV69Stub.so:${CONTAINER_LIB_PATH}/libQnnHtpV69Stub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnHtpV73CalculatorStub.so:${CONTAINER_LIB_PATH}/libQnnHtpV73CalculatorStub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnHtpV73Stub.so:${CONTAINER_LIB_PATH}/libQnnHtpV73Stub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnHtpV75Stub.so:${CONTAINER_LIB_PATH}/libQnnHtpV75Stub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnJsonProfilingReader.so:${CONTAINER_LIB_PATH}/libQnnJsonProfilingReader.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnSaver.so:${CONTAINER_LIB_PATH}/libQnnSaver.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnSystem.so:${CONTAINER_LIB_PATH}/libQnnSystem.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libQnnTFLiteDelegate.so:${CONTAINER_LIB_PATH}/libQnnTFLiteDelegate.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libSNPE.so:${CONTAINER_LIB_PATH}/libSNPE.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libSnpeDspV66Stub.so:${CONTAINER_LIB_PATH}/libSnpeDspV66Stub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libSnpeHta.so:${CONTAINER_LIB_PATH}/libSnpeHta.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libSnpeHtpPrepare.so:${CONTAINER_LIB_PATH}/libSnpeHtpPrepare.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libSnpeHtpV68CalculatorStub.so:${CONTAINER_LIB_PATH}/libSnpeHtpV68CalculatorStub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libSnpeHtpV68Stub.so:${CONTAINER_LIB_PATH}/libSnpeHtpV68Stub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libSnpeHtpV73CalculatorStub.so:${CONTAINER_LIB_PATH}/libSnpeHtpV73CalculatorStub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libSnpeHtpV73Stub.so:${CONTAINER_LIB_PATH}/libSnpeHtpV73Stub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libSnpeHtpV75CalculatorStub.so:${CONTAINER_LIB_PATH}/libSnpeHtpV75CalculatorStub.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libSnpeHtpV75Stub.so:${CONTAINER_LIB_PATH}/libSnpeHtpV75Stub.so")

# libs for QNN TFLite GPU delegate
HOST_FILES+=("-v ${HOST_LIB_PATH}/libadreno_utils.so:${CONTAINER_LIB_PATH}/libadreno_utils.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libCB.so:${CONTAINER_LIB_PATH}/libCB.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libOpenCL.so:${CONTAINER_LIB_PATH}/libOpenCL.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libOpenCL_adreno.so:${CONTAINER_LIB_PATH}/libOpenCL_adreno.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libdmabufheap.so.0:${CONTAINER_LIB_PATH}/libdmabufheap.so.0")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libdmabufheap.so.0.0.0:${CONTAINER_LIB_PATH}/libdmabufheap.so.0.0.0")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libgsl.so:${CONTAINER_LIB_PATH}/libgsl.so")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libpropertyvault.so.0:${CONTAINER_LIB_PATH}/libpropertyvault.so.0")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libpropertyvault.so.0.0.0:${CONTAINER_LIB_PATH}/libpropertyvault.so.0.0.0")
HOST_FILES+=("-v ${HOST_LIB_PATH}/libllvm-qcom.so:${CONTAINER_LIB_PATH}/libllvm-qcom.so")

HOST_devices+=("--device=/dev/dri/card0")
HOST_devices+=("--device=/dev/dri/renderD128")
HOST_devices+=("--device=/dev/kgsl-3d0")
HOST_devices+=("--device=/dev/dma_heap/system")
HOST_devices+=("--device=/dev/dma_heap/qcom,system")
HOST_devices+=("--device=/dev/fastrpc-cdsp")
HOST_devices+=("--device=/dev/v4l-subdev8")
HOST_devices+=("--device=/dev/video0")
HOST_devices+=("--device=/dev/video33")
if [ -e /dev/video2 ]; then
    HOST_devices+=("--device=/dev/video2")
fi

# Define Docker image and container names
IMAGE_NAME="qirp-docker"
CONTAINER_NAME="qirp-samples-container"

ai_model_list=( \
    MediaPipeHandDetector.tflite,https://huggingface.co/qualcomm/MediaPipe-Hand-Detection/resolve/0d0b12ccd12b96457185ff9cfab75eb7c7ab3ad6/MediaPipeHandDetector.tflite?download=true  \
    MediaPipeHandLandmarkDetector.tflite,https://huggingface.co/qualcomm/MediaPipe-Hand-Detection/resolve/0d0b12ccd12b96457185ff9cfab75eb7c7ab3ad6/MediaPipeHandLandmarkDetector.tflite?download=true  \
    anchors_palm.npy,https://raw.githubusercontent.com/zmurez/MediaPipePyTorch/65f2549ba35cd61dfd29f402f6c21882a32fabb1/anchors_palm.npy  \
    ResNet101Quantized.tflite,https://huggingface.co/qualcomm/ResNet101Quantized/resolve/653916aac7c732d28863aa449176299ba2890c15/ResNet101Quantized.tflite?download=true  \
    imagenet_labels.txt,https://raw.githubusercontent.com/quic/ai-hub-models/refs/heads/main/qai_hub_models/labels/imagenet_labels.txt  \
 )

#--------setup in qclinux -----------
function docker_check_install_depends(){
    # Check if Docker image exists
    if ! docker images --format "{{.Repository}}" | grep -w ^$IMAGE_NAME$ ;then
        echo "Docker image $IMAGE_NAME not found, loading from $IMAGE_PATH ..."
        if [ -f $IMAGE_PATH ];then
            docker load -i "$IMAGE_PATH"
            if [ $? -eq 0 ]; then
                echo "Docker image successfully loaded."
            else
                echo "Error loading Docker image."
                return  1
            fi
        else
            echo "no docker image $IMAGE_NAME in $IMAGE_PATH"
            #docker pull --platform=linux/arm64/v8 ros:$ROS_DISTRO
        fi
    else
        echo "Docker image $IMAGE_NAME already exists."
    fi

    # Check if Docker container exists
    if ! docker ps -a --format "{{.Names}}" | grep -w ^$CONTAINER_NAME$; then
        echo "Docker container $CONTAINER_NAME not found, starting..."
        docker run -d -it --rm \
            -e LOCAL_USER_NAME=$(whoami) \
            -e LOCAL_USER_ID=$(id | awk -F "(" '{print $1}' | sed 's/uid=//') \
            -e LOCAL_GROUP_ID=$(id | awk -F "(" '{print $2}' | awk -F " " '{print $NF}' | sed 's/gid=//') \
            -v $Linux_DIR:$Linux_DIR \
            ${HOST_FILES[@]} \
            ${HOST_devices[@]} \
            --network=host \
            --name=$CONTAINER_NAME \
            --security-opt seccomp=unconfined \
            $IMAGE_NAME:latest
        if [ $? -eq 0 ]; then
            echo "Docker container successfully started."
        else
            echo "Error starting Docker container."
            return  1
        fi

    else
        echo "Docker container $CONTAINER_NAME already exists."
    fi

    docker exec -it -u root $CONTAINER_NAME /bin/bash
    if [ $? -eq 0 ]; then
        echo "Docker container successfully started."
    else
        echo "Error starting Docker container."
        return  1
    fi
}
function linux_env_setup(){
    echo "Linux setup"

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
    export ADSP_LIBRARY_PATH=/usr/lib/rfsa/adsp:${ADSP_LIBRARY_PATH}
    setenforce 0
    export HOME=/opt
    source /usr/bin/ros_setup.sh
}

function check_network_connection() {
    local wifi_connected=0
    local ethernet_connected=0

    # Check WiFi
    local wifi_status=$(nmcli -t -f WIFI g)
    if [[ "$wifi_status" == "enabled" ]]; then
        local connection_status=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d':' -f2)
        if [[ -n "$connection_status" ]]; then
            echo "Connected to WiFi: $connection_status"
            wifi_connected=1
        else
            echo "Not connected to any WiFi network."
        fi
    else
        echo "WiFi is disabled."
    fi

    # Check Ethernet
    local ethernet_status=$(nmcli -t -f DEVICE,STATE dev | grep '^eth' | awk -F: '{print $2}')
    if [[ "$ethernet_status" == "connected" ]]; then
        echo "Ethernet is connected."
        ethernet_connected=1
    else
        echo "Ethernet is not connected."
    fi

    # Return 0 if either WiFi or Ethernet is connected
    if [[ $wifi_connected -eq 1 || $ethernet_connected -eq 1 ]]; then
        return 0
    else
        return 1
    fi
}

function download_ai_model(){
    if [ ! -d /opt/model/ ];then
        echo "no model direction in /opt/model"
        mkdir /opt/model
    fi

    for model in "${ai_model_list[@]}"; do
        # using IFS parse name and link
        IFS=',' read -r name link <<< "$model"
        if [ -f /opt/model/$name ];then
            echo "/opt/model/$name has download in device"
        else
            wget -O /opt/model/$name $link
            if [ $? -eq 0 ]; then
                echo "echo Downloading $name from $link  successfully "
            else
                echo "Downloading $name from $link  fail"
            fi
        fi
    done
}

function qli_show_help() {
    echo "Usage: source /usr/share/qirp-setup.sh [OPTION]"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message."
    echo "  -m, --model       Download AI sample models required for execution."
    echo "  -d, --docker      Load Docker on the device."
    echo "  --docker_path     Specify the local Docker image path (default: /home/qirp-docker.tar.gz)."
    echo ""
    echo "Examples:"
    echo "  source /usr/share/qirp-setup.sh --help"
    echo "  source /usr/share/qirp-setup.sh --model"
    echo "  source /usr/share/qirp-setup.sh --docker --docker_path /your/custom/path.tar.gz"
}

#--------------main point of qli--------------#
qli_main(){    
    case "$1" in
        -h|--help)
            qli_show_help
            return 1
            ;;
        -m|--model)
            check_network_connection
            if [[ $? -eq 0 ]]; then
                echo "Network checks passed successfully!"
                download_ai_model
            else
                echo "Something went wrong. Please check network status."
                return 1
            fi
            ;;
        -d|--docker)
            echo "building docker image..."
            date -s "2025-03-20"
            if [ "$2" == "--docker_path" ]; then
                echo "loading docker path from $3"
                IMAGE_PATH=$3
            else
                IMAGE_PATH="/home/qirp-docker.tar.gz"
            fi
            docker_check_install_depends
            if [[ $? -eq 0 ]]; then
                echo "docker load successfully!"
            else
                echo "docker load  wrong."
                return 1
            fi
            ;;
        *)
            echo "Setting up QIRP QCLinux for execution on device"
        ;;
    esac
    linux_env_setup
    echo "Setting up QIRP QCLinux successfully"
}


ROS_DISTRO=jazzy


apt_packages_base=( \
)
#qrb ros packages
apt_packages_base+=( \    
)
model=()
model_label=()

pip_packages_base=( \
    typing_extensions  \
    pytesseract \
)

qrb_ros_node=( \
)

apt_packages_sample=()
pip_packages=()

DIR=/home/ubuntu/
#--------setup in ubuntu -----------
function ubuntu_setup(){
    try_times=5     
    if [ ! -f "$DIR/env_check" ]; then
        scripts_env_setup
        download_qrb_ros_node $try_times
        download_depends
        touch $DIR/env_check
    fi    
    setup_env
}
function setup_env(){
    source /opt/ros/$ROS_DISTRO/setup.sh
    export USB_CAMERA_PATH=$(v4l2-ctl --list-devices | grep -A1 "USB Camera" | tail -n1 | tr -d ' \t')
}
function scripts_env_setup(){
    
    sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common curl 
    if [ $? -eq 0 ]; then
        echo "apt-get install -y  software-properties-common curl successfully "
    else
        echo "apt-get install -y  software-properties-common curl  fail"
        exit 1
    fi
    
    #add qualcomm  ppa
    echo "Add qualcomm  ppa , wait few minutes..."
    #echo "deb [trusted=yes] http://10.64.25.66:8888 ./" | sudo tee -a /etc/apt/sources.list
    sudo add-apt-repository -y ppa:ubuntu-qcom-iot/qcom-noble-ppa
    sudo add-apt-repository -y ppa:ubuntu-qcom-iot/qirp 
        
    #install qnn libs in real ubuntu env, not in docker
    if [ -f /.dockerenv ]; then
        echo "current in docker , not install qnn and ros base"
        pip3 uninstall numpy
    else          
        #add ros apt source
        sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null  
        if [ $? -eq 0 ]; then
            echo "add ros base successfully "
        else
            echo "add ros base fail"
            exit 1
        fi
    fi
    sudo apt update && sudo apt upgrade -y

    echo "apt install base pkgs ${apt_packages_base[@]} ... "
    #install apt pkgs
    for package in "${apt_packages_base[@]}"; do
        sudo  DEBIAN_FRONTEND=noninteractive apt-get install -y $package   --fix-missing
        if [ $? -eq 0 ]; then
            echo "apt-get install -y  $package successfully "
        else
            echo "apt-get install -y  $package  fail"
            exit 1
        fi
    done
    
    echo "pip install base pkgs ${pip_packages_base[@]} ... "
    #can't pip install in ubuntu24.04 docker 
    if [ -f /usr/lib/python3.12/EXTERNALLY-MANAGED ]; then
        sudo mv /usr/lib/python3.12/EXTERNALLY-MANAGED  /usr/lib/python3.12/EXTERNALLY-MANAGED.bk
    fi
    
    #install pip pkgs
    for package in "${pip_packages_base[@]}"; do
        pip install $package
        if [ $? -eq 0 ]; then
            echo "pip install $package successfully "
        else
            echo "pip install $package fail"
            exit 1
        fi  
    done
    
}

function download_qrb_ros_node(){
    cd $DIR/src
    local N=$1
    if [ $((N -1)) == 0 ];then
        echo "try to git clone $node $try_times times, fail"
        exit 1
    fi

    for node in ${qrb_ros_node[@]};do
        if [ -f $DIR/src/$(echo $node | awk -F'/' '{print $NF}').done ]; then 
            echo "$node has been download in $DIR/src"
        else
            git clone $node
            if [ $? -eq 0 ]; then
                echo "git clone $node successfully "
                touch $DIR/src/$(echo $node | awk -F'/' '{print $NF}').done
            else
                download_qrb_ros_node $((N-1))
                exit 1
            fi
        fi
    done
}

function download_depends(){
    echo "apt install pkgs ${apt_packages[@]} ... "
    #install apt pkgs
    search_item=""
    for package in "${apt_packages[@]}"; do
        if [[ $package == $search_item ]];then
            echo "$package has been install"
        else
            sudo  DEBIAN_FRONTEND=noninteractive apt-get install -y $package   --fix-missing
            if [ $? -eq 0 ]; then
                echo "apt-get install -y  $package successfully "
            else
                echo "apt-get install -y  $package  fail"
                exit 1
            fi
            search_item+=$package
        fi
    done    
    echo "pip install base pkgs ${pip_packages[@]} ... "
    search_item=""
    #install pip pkgs
    for package in "${pip_packages[@]}"; do
        if [[ $package == $search_item ]];then
            echo "$package has been install"
        else
            sudo pip3 install --user --upgrade --force-reinstall $package
            if [ $? -eq 0 ]; then
                echo "pip install $package successfully "
            else
                echo "pip install $package fail"
                exit 1
            fi
            search_item+=$package
        fi
    done
}

function ubuntu_show_help() {
    echo "Usage: source /usr/share/qirp-setup.sh [OPTION]"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message."
    echo "  --update,         Force update qirp sdk."
    echo ""
    echo "Examples:"
    echo "  source /usr/share/qirp-setup.sh --help"
    echo "  source /usr/share/qirp-setup.sh --update"
}

#--------------main point of ubuntu--------------#
ubuntu_main(){
    
    case "$1" in
        -h|--help)
            ubuntu_show_help
            return 1
            ;;
        --update)
            scripts_env_setup
            if [[ $? -eq 0 ]]; then
                echo "setup qirp sdk successfully!"
            else
                echo "Something went wrong. Please check error info."
                return 1
            fi
            ;;       
        *)
            echo "Setting up QIRP QCLinux for execution on device"
        ;;
    esac
    ubuntu_setup
    echo "Setting up QIRP QCLinux successfully"
}

#--------------main point
# if (target:ubuntu):
#     apt install <toolchain list>
function main(){
    if lsb_release -a 2>/dev/null | grep -q "Ubuntu"; then        
        ubuntu_main $1 $2 $3
    else
        qli_main $1 $2 $3
    fi
}
main $1 $2 $3
