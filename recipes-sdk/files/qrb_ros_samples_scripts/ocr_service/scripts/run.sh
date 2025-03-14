# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
# This project is currently under active development
#!/bin/bash
unset ADB_ID
unset SSH_IP
unset SSH_KEY
if [ "$#" -eq 0 ]; then
    echo "Please provide at least one argument for adb/ssh serialNumber."
    exit 1
fi

while getopts ":s:i:" opt; do
    case $opt in
        s)
            INPUT="$OPTARG"
            # Check if the input is an IP address
            if [[ $INPUT =~ ^10\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                SSH_IP="$INPUT"
                echo "Input is an IP address: $SSH_IP"
            elif [[ $INPUT =~ ^[a-f0-9]{8}$ ]]; then
                ADB_ID="$INPUT"
                echo "Input is an ADB device ID: $ADB_ID"
            else
                echo "Invalid input: $INPUT"
                exit 1
            fi
            ;;
	i)
            SSH_KEY="$OPTARG"
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
        *)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

package_name=ocr_service
image_topic=test
picture_name=digital_720p.png
picture_target_path=/usr

run_by_adb(){
    adb push ./$picture_name $picture_target_path
    adb -s $ADB_ID shell "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 run $package_name ocr_client $image_topic" &
    adb -s $ADB_ID shell "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 run $package_name ocr_testnode --topic $image_topic --picture $picture_target_path/$picture_name" &
    adb -s $ADB_ID shell "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 run $package_name ocr_server"
    wait

    echo "run $package_name failed"
    echo "Please make sure QIRP and $package_name are installed on device."
}

run_by_ssh(){
    if [ -z "$SSH_KEY" ]; then
        scp ./$picture_name root@$SSH_IP:$picture_target_path
        ssh root@$SSH_IP "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 run $package_name ocr_client $image_topic" &
        ssh root@$SSH_IP "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 run $package_name ocr_testnode --topic $image_topic --picture $picture_target_path/$picture_name" &
        ssh root@$SSH_IP "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 run $package_name ocr_server"
    else
        scp -i $SSH_KEY ./$picture_name root@$SSH_IP:$picture_target_path
        ssh -i $SSH_KEY root@$SSH_IP "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 run $package_name ocr_client $image_topic" &
        ssh -i $SSH_KEY root@$SSH_IP "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 run $package_name ocr_testnode --topic $image_topic --picture $picture_target_path/$picture_name" &
        ssh -i $SSH_KEY root@$SSH_IP "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 run $package_name ocr_server"
    fi
    wait

    echo "run $package_name failed"
    echo "Please make sure QIRP and $package_name are installed on device."
}

if [ -n "$ADB_ID" ]; then
    echo "Running on ADB device: $ADB_ID"
    run_by_adb
elif [ -n "$SSH_IP" ]; then
    echo "Running on SSH device: $SSH_IP"
    run_by_ssh
else
    echo "No device specified. Please provide an ADB ID or SSH IP address."
    exit 1
fi