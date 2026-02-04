#!/usr/bin/env bash

# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
#
# This script sets up the environment for QIRP SDK and optionally downloads AI models.

# Log function for consistent output
log_info() {
    echo "[INFO] $1"
}

log_error() {
    echo "[ERROR] $1" >&2
}

ai_model_list=(
    MediaPipeHandDetector.bin,https://huggingface.co/qualcomm/MediaPipe-Hand-Detection/resolve/7c266a43cf0328c5e00c96007a339ae41ddffa65/MediaPipeHandDetector.bin?download=true
    MediaPipeHandLandmarkDetector.bin,https://huggingface.co/qualcomm/MediaPipe-Hand-Detection/resolve/7c266a43cf0328c5e00c96007a339ae41ddffa65/MediaPipeHandLandmarkDetector.bin?download=true
    anchors_palm.npy,https://raw.githubusercontent.com/zmurez/MediaPipePyTorch/65f2549ba35cd61dfd29f402f6c21882a32fabb1/anchors_palm.npy
    ResNet101_w8a8.bin,https://huggingface.co/qualcomm/ResNet101/resolve/121564046ebb2353d4a0aa67bf89c11e0c8e80d9/ResNet101_w8a8.bin?download=true
    imagenet_labels.txt,https://raw.githubusercontent.com/quic/ai-hub-models/refs/heads/main/qai_hub_models/labels/imagenet_labels.txt
    HRNetPose.bin,https://huggingface.co/qualcomm/HRNetPose/resolve/6011b6e69a84dad8f53fb555b11035a5e26c8755/HRNetPose.bin?download=true
    MediaPipeFaceDetector.bin,https://huggingface.co/qualcomm/MediaPipe-Face-Detection/resolve/0dd669a326ec24a884e51b82741997299d937705/MediaPipeFaceDetector.bin
    MediaPipeFaceLandmarkDetector.bin,https://huggingface.co/qualcomm/MediaPipe-Face-Detection/resolve/0dd669a326ec24a884e51b82741997299d937705/MediaPipeFaceLandmarkDetector.bin
    anchors_face.npy,https://raw.githubusercontent.com/zmurez/MediaPipePyTorch/65f2549ba35cd61dfd29f402f6c21882a32fabb1/anchors_face.npy
    Depth-Anything-V2.bin,https://huggingface.co/qualcomm/Depth-Anything-V2/resolve/19ce3645e11de17eed7e869eebcc07dd352834f3/Depth-Anything-V2.bin?download=true
)

#--------setup in qclinux -----------
function linux_env_setup(){
    log_info "Starting Linux environment setup..."

    # Common environment variables export
    export PATH="/bin/aarch64-oe-linux-gcc11.2:/usr/bin:/usr/bin/qim:${PATH}"
    export LD_LIBRARY_PATH="/lib/aarch64-oe-linux-gcc11.2:/usr/lib:/usr/lib/qim:/lib:${LD_LIBRARY_PATH}"

    # ROS environment variables export
    export AMENT_PREFIX_PATH="/usr:${AMENT_PREFIX_PATH}"
    export PYTHONPATH="/usr/lib/python3.10/site-packages:${PYTHONPATH}"

    # GStreamer environment variables export
    export GST_PLUGIN_PATH="/usr/lib/qim/gstreamer-1.0:/usr/lib/gstreamer-1.0:${GST_PLUGIN_PATH}"
    export GST_PLUGIN_SCANNER="/usr/libexec/qim/gstreamer-1.0/gst-plugin-scanner:/usr/libexec/gstreamer-1.0/gst-plugin-scanner:${GST_PLUGIN_SCANNER}"

    # QNN environment variables export
    export ADSP_LIBRARY_PATH="/usr/lib/rfsa/adsp:${ADSP_LIBRARY_PATH}"
    export HOME="/opt" # Setting HOME to /opt might have unintended side effects for other tools/scripts.
    
    log_info "Sourcing /opt/ros/jazzy/setup.sh..."
    if ! source "/opt/ros/jazzy/setup.sh"; then
        log_error "Failed to source /opt/ros/jazzy/setup.sh . Please check if the file exists and is executable."
        return 1
    fi
    log_info "Linux environment setup complete."
}

function check_network_connection() {
    log_info "Checking network connection..."
    local wifi_connected=0
    local ethernet_connected=0

    # Check WiFi
    local wifi_status=$(nmcli -t -f WIFI g 2>/dev/null || true)
    if [[ "$wifi_status" == "enabled" ]]; then
        local connection_status=$(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d':' -f2 || true)
        if [[ -n "$connection_status" ]]; then
            log_info "Connected to WiFi: $connection_status"
            wifi_connected=1
        else
            log_info "Not connected to any WiFi network."
        fi
    else
        log_info "WiFi is disabled or nmcli is not available."
    fi

    # Check Ethernet
    local ethernet_status=$(nmcli -t -f DEVICE,STATE dev | grep '^eth' | awk -F: '{print $2}' || true)
    if [[ "$ethernet_status" == "connected" ]]; then
        log_info "Ethernet is connected."
        ethernet_connected=1
    else
        log_info "Ethernet is not connected or nmcli is not available."
    fi

    # Return 0 if either WiFi or Ethernet is connected
    if [[ $wifi_connected -eq 1 || $ethernet_connected -eq 1 ]]; then
        log_info "Network connection detected."
        return 0
    else
        log_error "No active network connection (WiFi or Ethernet) detected."
        return 1
    fi
}

function download_ai_model(){
    local model_dir="/opt/model"
    log_info "Attempting to download AI models to $model_dir..."

    if [ ! -d "$model_dir" ]; then
        log_info "Creating model directory: $model_dir"
        if ! mkdir -p "$model_dir"; then
            log_error "Failed to create directory $model_dir. Exiting."
            return 1
        fi
    fi

    for model_entry in "${ai_model_list[@]}"; do
        # using IFS parse name and link
        IFS=',' read -r name link <<< "$model_entry"
        local model_path="${model_dir}/${name}"

        if [ -f "$model_path" ]; then
            log_info "${name} already exists at ${model_path}. Skipping download."
        else
            log_info "Downloading ${name} from ${link} to ${model_path}..."
            if wget -O "$model_path" "$link"; then
                log_info "Successfully downloaded ${name}."
            else
                log_error "Failed to download ${name} from ${link}. Please check the URL and your network."
            fi
        fi
    done
    log_info "AI model download process complete."
}

function qli_show_help() {
    log_info "Displaying help message."
    cat << EOF
Usage: source /usr/share/qirp-setup.sh [OPTION]

Options:
  -h, --help        Show this help message.
  -m, --model       Download AI sample models required for execution.

Examples:
  source /usr/share/qirp-setup.sh --help
  source /usr/share/qirp-setup.sh --model

EOF
}

#--------------main point of qli--------------#
qli_main(){
    local cmd_arg="${1:-}" # Default to empty string if no argument is provided.

    case "$cmd_arg" in
        -h|--help)
            qli_show_help
            return 0 # Exit successfully after showing help.
            ;;
        -m|--model)
            log_info "Model download option selected."
            if check_network_connection; then
                log_info "Network check passed. Proceeding with model download."
                download_ai_model
            else
                log_error "Network checks failed. Cannot download models. Exiting."
                return 1
            fi
            ;;
        "")
            log_info "No specific option provided. Setting up Robotics SDK for execution on device."
            ;;
        *)
            log_error "Invalid option: $cmd_arg. Use -h or --help for usage information."
            return 1
            ;;
    esac

    # Always attempt to set up the Linux environment, unless an error occurred previously.
    if linux_env_setup; then
        log_info "Robotics SDK setup successfully."
    else
        log_error "Robotics SDK setup failed."
        return 1
    fi
}

# Call the main function with provided arguments.
qli_main "$@"
