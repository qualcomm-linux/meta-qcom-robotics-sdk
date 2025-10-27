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

package_name=qrb_ros_battery
deploy_by_adb(){
    adb -s $ADB_ID shell "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 run $package_name battery_node" &
    adb -s $ADB_ID shell "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 topic echo /battery_stats"
    wait
    echo "run $package_name failed"
    echo "Please make sure QIRP and $package_name are installed on device."
}

deploy_by_ssh(){
    if [ -z "$SSH_KEY" ]; then
        ssh root@$SSH_IP "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 run $package_name battery_node" &
        ssh root@$SSH_IP "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 topic echo /battery_stats"
    else
        ssh -i $SSH_KEY root@$SSH_IP "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 run $package_name battery_node" &
        ssh -i $SSH_KEY root@$SSH_IP "export HOME=/home && source /usr/bin/ros_setup.sh && source /usr/share/qirp-setup.sh && ros2 topic echo /battery_stats"
    fi
    wait
    echo "run $package_name failed"
    echo "Please make sure QIRP and $package_name are installed on device."
}

if [ -n "$ADB_ID" ]; then
    echo "Deploying to ADB device: $ADB_ID"
    deploy_by_adb
elif [ -n "$SSH_IP" ]; then
    echo "Deploying to SSH device: $SSH_IP"
    deploy_by_ssh
else
    echo "No device specified. Please provide an ADB ID or SSH IP address."
    exit 1
fi