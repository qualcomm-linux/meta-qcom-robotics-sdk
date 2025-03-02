#/bin/bash

# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
# current dir

# Define Docker image and container names
IMAGE_NAME="qirp_docker"
CONTAINER_NAME="qirp-samples-container"

linux_docker_param=$1
if [ "$2" == "--docker_path" ]; then
    echo "loading docker path from $3"
    IMAGE_PATH=$3
else
    IMAGE_PATH="/home/qirp_docker.tar.gz"
fi

config_file="config.yaml"
ROS_DISTRO=jazzy

model=()
model_label=()
apt_packages_base=( \
    ros-$ROS_DISTRO-ros-base \
    ros-$ROS_DISTRO-cv-bridge \
    ros-$ROS_DISTRO-vision-msgs \
    ros-$ROS_DISTRO-sensor-msgs \
    weston-qcom \
    gstreamer1.0-plugins-qcom \
    gstreamer1.0-tools \
    camxapi-kt \
    libqmmf-dev \
    syslog-plumber-dev \
    libimage-transport-dev \
    qnn-tools \
    libqnn-dev \
    libqnn1 \
    libsndfile1-dev \
    libhdf5-dev \
    libopencv-dev \
    python3-numpy \
    python3-opencv \
	python-is-python3 \
    python3-pip \
    python3-colcon-common-extensions \
    python3-pandas \
    wget \
    libpulse-dev \
)

pip_packages_base=(
    numpy==1.24.4 \
    requests \
    vcstool \
    pytesseract \
)

qrb_ros_node=( \
    https://github.com/quic-qrb-ros/qrb_ros_camera.git \
    https://github.com/quic-qrb-ros/lib_mem_dmabuf.git \
    https://github.com/quic-qrb-ros/qrb_ros_transport.git \
    https://github.com/quic-qrb-ros/qrb_ros_imu.git \
    https://github.com/quic-qrb-ros/qrb_ros_transport.git \
    https://github.com/quic-qrb-ros/qrb_ros_interfaces.git \
    https://github.com/quic-qrb-ros/qrb_ros_audio_service.git \
    https://github.com/quic-qrb-ros/qrb_ros_audio_common.git \
    https://github.com/quic-qrb-ros/qrb_ros_yolo_processor.git \
)

#https://github.com/quic-qrb-ros/qrb_ros_nn_inference.git \

apt_packages_sample=()
pip_packages=()


#---------main entry point ------------

function check_workdir(){
    # check src dir if exit
    if [ -d "$DIR/src" ]; then
        echo "workdir is $DIR "
        echo "source code dir is $DIR/src "
    else
        echo "no $DIR , creat it..."
        mkdir -p "$DIR/src"
        if [ $? -eq 0 ]; then
            echo "$DIR/src successfully create"
        else
            echo "create $DIR fail"
            exit 1
        fi
    fi
    # check model dir if exit
    if [ -d "$DIR/model" ]; then
        echo "model code dir is $DIR/model "
    else
        echo "no $DIR/model , creat it..."
        mkdir -p "$DIR/model"
        if [ $? -eq 0 ]; then
            echo "$DIR/model successfully create"
        else
            echo "create $DIR fail"
            exit 1
        fi
    fi

    cd $DIR

    THIS_SCRIPT=$(readlink -f ${BASH_SOURCE[0]})
    script_dir="$(dirname "${THIS_SCRIPT}")"
}
#--------setup in ubuntu -----------
function ubuntu_setup(){
    try_times=5
    if [ ! -f "$DIR/env_check" ]; then
        #git clone qirp-ros-samples /apt install
        scripts_env_setup
        download_qrb_ros_node $try_times
        touch $DIR/env_check
    fi
    read_configuration
    download_model  $try_times
    download_model_label $try_times
    download_depends
    #tensorflow_setup
    #build depends ros nodes
    source /opt/ros/$ROS_DISTRO/setup.sh
    cd $DIR; colcon build --executor sequential
    if [ $? -eq 0 ]; then
        echo "colcon build ros nodes successfully "
    else
        echo "colcon build ros nodes fail"
        exit 1
    fi
    cd -
    setup_env
}
function setup_env(){
    source /opt/ros/$ROS_DISTRO/setup.sh
    source $DIR/install/setup.bash
    if [ $? -eq 0 ]; then
        echo "setup_env successfully "
    else
        echo "setup_env  fail"
        exit 1
    fi

}
function scripts_env_setup(){

    #download depends
    sudo apt update && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common curl
    if [ $? -eq 0 ]; then
        echo "apt-get install -y  software-properties-common curl successfully "
    else
        echo "apt-get install -y  software-properties-common curl  fail"
        exit 1
    fi

    #add qualcomm ppa
    #sudo add-apt-repository ppa:carmel-team/jammy-release --login
    echo 'y' | sudo add-apt-repository ppa:ubuntu-qcom-iot/qcom-ppa
    if [ $? -eq 0 ]; then
        echo "add-apt-repository ppa:ubuntu-qcom-iot/qcom-ppa successfully "
    else
        echo "add-apt-repository ppa:ubuntu-qcom-iot/qcom-ppa fail"
        exit 1
    fi

    #install ros base
    sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

    if [ $? -eq 0 ]; then
        echo "add ros base successfully "
    else
        echo "add ros base fail"
        exit 1
    fi


    sudo apt update
    sudo apt upgrade
    echo "apt install base pkgs ${apt_packages_base[@]} ... "
    #install apt pkgs
    for package in "${apt_packages_base[@]}"; do
        sudo  DEBIAN_FRONTEND=noninteractive apt-get install -y $package
        if [ $? -eq 0 ]; then
            echo "apt-get install -y  $package successfully "
        else
            echo "apt-get install -y  $package  fail"
            exit 1
        fi
    done
    echo "pip install base pkgs ${pip_packages_base[@]} ... "
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

    #install yq tool
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_arm64
    if [ $? -eq 0 ]; then
        echo "add yq tool successfully "
    else
        echo "add yq tool fail"
        exit 1
    fi

    sudo chmod a+x /usr/local/bin/yq

    #extra ops for camera
    sudo cp /usr/include/log/log.h /usr/include/log.h
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
function read_configuration(){
    # find all config file and read apt/pip/ros nodes
    conf=$(find "$DIR" -type f -name $config_file)
    for file in $conf; do
        echo "Reading conf file: $file"
        model+=($(yq eval '.model[]' $file))
        model_label+=($(yq eval '.model_label[]' $file))
        apt_packages+=($(yq eval '.apt[]' $file))
        pip_packages+=($(yq eval '.pip[]' $file))
    done

    echo "remove the repeat packages"
    model=($(echo "${model[@]}" | tr ' ' '\n' | awk '!seen[$0]++'))
    model_label=($(echo "${model_label[@]}" | tr ' ' '\n' | awk '!seen[$0]++'))
    apt_packages=($(echo "${apt_packages[@]}" | tr ' ' '\n' | awk '!seen[$0]++'))
    pip_packages=($(echo "${pip_packages[@]}" | tr ' ' '\n' | awk '!seen[$0]++'))
    echo "----------------------------------------"
    echo "need to download model ${model[@]}"
    echo "need to download model_label ${model_label[@]}"
    echo "need to apt install ${apt_packages[@]}"
    echo "need to pip install ${pip_packages[@]}"
    echo "----------------------------------------"
}
function download_model(){
    local N=$1
    if [ $((N -1)) == 0 ];then
        echo "try to download_model $try_times times, fail"
        exit 1
    fi
    IFS=','

    if [ ${#model[@]} -ne 0 ]; then
        for smodel in "${model[@]}"; do
            read model_name link <<< $smodel
            if [ -f $DIR/model/$model_name.done ]; then
                echo "$model_name has been download in $DIR/model"
            else
                wget -O $DIR/model/$model_name $link
                if [ $? -eq 0 ]; then
                    echo "download $model_name successfully "
                    touch $DIR/model/$model_name.done
                else
                    download_model $((N-1))
                    exit 1
                fi
            fi
        done
    fi
}
function download_model_label(){
    local N=$1
    if [ $((N -1)) == 0 ];then
        echo "try to download_model $try_times times, fail"
        exit 1
    fi
    IFS=','
    if [ ${#model_label[@]} -ne 0 ]; then
        for smodel in "${model_label[@]}"; do
            read label_name link <<< $smodel
            if [ -f $DIR/model/$label_name.done ]; then
                echo "$label_name has been download in $DIR/model"
            else
                wget -O $DIR/model/$label_name $link
                if [ $? -eq 0 ]; then
                    echo "download $label_name successfully "
                    touch $DIR/model/$label_name.done
                else
                    download_model_label $((N-1))
                    exit 1
                fi
            fi
        done
    fi

}
function download_depends(){
    echo "apt install pkgs ${apt_packages[@]} ... "
    #install apt pkgs
    search_item=""
    for package in "${apt_packages[@]}"; do
        if [[ $package == $search_item ]];then
            echo "$package has been install"
        else
            sudo  DEBIAN_FRONTEND=noninteractive apt-get install -y $package
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
            sudo pip install $package
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

#--------setup in qclinux -----------
function docker_check_install_depends(){
    # Check if Docker image exists
    if ! docker images | grep -q "$IMAGE_NAME"; then
        echo "Docker image $IMAGE_NAME not found, loading from $IMAGE_PATH ..."
        if [ -f $IMAGE_PATH ];then
            docker load -i "$IMAGE_PATH"
            if [ $? -eq 0 ]; then
                echo "Docker image successfully loaded."
            else
                echo "Error loading Docker image."
                exit 1
            fi
        else
            echo "no docker image $IMAGE_NAME in $IMAGE_PATH"
            #docker pull --platform=linux/arm64/v8 ros:$ROS_DISTRO
        fi
    else
        echo "Docker image $IMAGE_NAME already exists."
    fi

    # Check if Docker container exists
    if ! docker ps -a | grep -q "$CONTAINER_NAME"; then
        echo "Docker container $CONTAINER_NAME not found, starting..."
        docker run -d -it \
            -e LOCAL_USER_NAME=$(whoami) \
            -e LOCAL_USER_ID=$(id | awk -F "(" '{print $1}' | sed 's/uid=//') \
            -e LOCAL_GROUP_ID=$(id | awk -F "(" '{print $2}' | awk -F " " '{print $NF}' | sed 's/gid=//') \
            -v /$DIR/:/$DIR \
            --name=$CONTAINER_NAME \
            --security-opt seccomp=unconfined \
            $IMAGE_NAME:latest /bin/bash
        if [ $? -eq 0 ]; then
            echo "Docker container successfully started."
        else
            echo "Error starting Docker container."
            exit 1
        fi
    else
        echo "Docker container $CONTAINER_NAME already exists."
    fi
}
function linux_setup(){
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
    export ADSP_LIBRARY_PATH=/lib/aarch64-oe-linux-gcc11.2:/lib/hexagon-v68/unsigned:${ADSP_LIBRARY_PATH}

    if [[ $linux_docker_param == "docker" ]];then
        echo "building docker image..."
        if [ ! -f "$DIR/env_check" ]; then
            docker_check_install_depends
            #docker exec -it $CONTAINER_NAME bash -c "source /opt/ros/$ROS_DISTRO/setup.sh;cd $DIR; colcon build --executor sequential"
            touch $DIR/env_check
        fi
    fi
}


#--------------main point
# if (target:ubuntu):
#     apt install <toolchain list>
function main(){
    if lsb_release -a 2>/dev/null | grep -q "Ubuntu"; then
        DIR="/home/ubuntu/qirp-sdk"
        check_workdir
        ubuntu_setup
    else
        linux_setup
    fi
}
main
