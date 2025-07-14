#/bin/bash

# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
# current dir

ai_model_list=( \
    MediaPipeHandDetector.tflite,https://huggingface.co/qualcomm/MediaPipe-Hand-Detection/resolve/0d0b12ccd12b96457185ff9cfab75eb7c7ab3ad6/MediaPipeHandDetector.tflite?download=true  \
    MediaPipeHandLandmarkDetector.tflite,https://huggingface.co/qualcomm/MediaPipe-Hand-Detection/resolve/0d0b12ccd12b96457185ff9cfab75eb7c7ab3ad6/MediaPipeHandLandmarkDetector.tflite?download=true  \
    anchors_palm.npy,https://raw.githubusercontent.com/zmurez/MediaPipePyTorch/65f2549ba35cd61dfd29f402f6c21882a32fabb1/anchors_palm.npy  \
     ResNet101_w8a8.bin,https://huggingface.co/qualcomm/ResNet101/resolve/121564046ebb2353d4a0aa67bf89c11e0c8e80d9/ResNet101_w8a8.bin?download=true \
    imagenet_labels.txt,https://raw.githubusercontent.com/quic/ai-hub-models/refs/heads/main/qai_hub_models/labels/imagenet_labels.txt  \
 )

#--------setup in qclinux -----------
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
    export HOME=/opt
    source /usr/bin/ros_setup.sh
}

function check_network_connection() {
    local wifi_status=$(nmcli -t -f WIFI g)

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
        echo "creating  model path : /opt/model"
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
    echo ""
    echo "Examples:"
    echo "  source /usr/share/qirp-setup.sh --help"
    echo "  source /usr/share/qirp-setup.sh --model"
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
        *)
            echo "Setting up QIRP QCLinux for execution on device"
        ;;
    esac
    linux_env_setup
    echo "Setting up QIRP QCLinux successfully"
}

qli_main $1
