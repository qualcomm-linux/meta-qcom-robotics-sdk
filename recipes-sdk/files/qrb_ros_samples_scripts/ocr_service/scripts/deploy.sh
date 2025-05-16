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

scriptdir_ocr_service="$(dirname "${THIS_SCRIPT}")"
package_name_msg=ocr_msg
package_name_service=ocr_service
package_path_msg=ocr_msg
package_path_service=ocr_ros2node

deploy_by_adb(){
    cd $scriptdir_ocr_service/../install/$package_name_msg
    tar czvf $package_name_msg.tar.gz include lib share
    if [[ $? -ne 0 ]]; then
        echo "deploy $package_name_msg failed"
        echo "Please run build.sh before execute this script."
        exit 1
    fi

    adb push $package_name_msg.tar.gz /usr/
    if [[ $? -ne 0 ]]; then
        echo "deploy $package_name_msg failed"
        echo "Please make sure connect with device before execute this script."
        exit 1
    fi

    result=$(adb -s $ADB_ID shell "tar -zxf /usr/$package_name_msg.tar.gz -C /usr/")
    if [[ $? -ne 0 ]]; then
        echo "deploy $package_name_msg failed"
        echo "Please make sure connect with device before execute this script."
    elif [[ $result =~ "Error" ]]; then
        echo "deploy $package_name_msg failed"
        echo "Please make sure QIRP is installed on device before execute this script."
    else
        echo "deploy $package_name_msg successfully"
    fi

    cd ../../install/$package_name_service
    tar czvf $package_name_service.tar.gz lib share
    if [[ $? -ne 0 ]]; then
        echo "deploy $package_name_service failed"
        echo "Please run build.sh before execute this script."
        exit 1
    fi

    adb push $package_name_service.tar.gz /usr/
    if [[ $? -ne 0 ]]; then
        echo "deploy $package_name_service failed"
        echo "Please make sure connect with device before execute this script."
        exit 1
    fi

    result=$(adb -s $ADB_ID shell "tar -zxf /usr/$package_name_service.tar.gz -C /usr/")
    if [[ $? -ne 0 ]]; then
        echo "deploy $package_name_service failed"
        echo "Please make sure connect with device before execute this script."
    elif [[ $result =~ "Error" ]]; then
        echo "deploy $package_name_service failed"
        echo "Please make sure QIRP is installed on device before execute this script."
    else
        echo "deploy $package_name_service successfully"
    fi
}

deploy_by_ssh(){
    cd $scriptdir_ocr_service/../install/$package_name_msg
    tar czvf $package_name_msg.tar.gz include lib share
    if [[ $? -ne 0 ]]; then
        echo "deploy $package_name_msg failed"
        echo "Please run build.sh before execute this script."
        exit 1
    fi
    if [ -z "$SSH_KEY" ]; then
        scp $package_name_msg.tar.gz root@$SSH_IP:/usr/
        if [[ $? -ne 0 ]]; then
            echo "deploy $package_name_msg failed"
            echo "Please make sure connect with device before execute this script."
            exit 1
        fi

        result=$(ssh root@$SSH_IP "tar -zxf /usr/$package_name_msg.tar.gz -C /usr/")
        if [[ $? -ne 0 ]]; then
            echo "deploy $package_name_msg failed"
            echo "Please make sure connect with device before execute this script."
        elif [[ $result =~ "Error" ]]; then
            echo "deploy $package_name_msg failed"
            echo "Please make sure QIRP is installed on device before execute this script."
        else
            echo "deploy $package_name_msg successfully"
        fi
    else
         scp -i $SSH_KEY $package_name_msg.tar.gz root@$SSH_IP:/usr/
        if [[ $? -ne 0 ]]; then
            echo "deploy $package_name_msg failed"
            echo "Please make sure connect with device before execute this script."
            exit 1
        fi

        result=$(ssh -i $SSH_KEY root@$SSH_IP "tar -zxf /usr/$package_name_msg.tar.gz -C /usr/")
        if [[ $? -ne 0 ]]; then
            echo "deploy $package_name_msg failed"
            echo "Please make sure connect with device before execute this script."
        elif [[ $result =~ "Error" ]]; then
            echo "deploy $package_name_msg failed"
            echo "Please make sure QIRP is installed on device before execute this script."
        else
            echo "deploy $package_name_msg successfully"
        fi
    fi

    cd ../../install/$package_name_service
    tar czvf $package_name_service.tar.gz lib share
    if [[ $? -ne 0 ]]; then
        echo "deploy $package_name_service failed"
        echo "Please run build.sh before execute this script."
        exit 1
    fi
    if [ -z "$SSH_KEY" ]; then
        scp $package_name_service.tar.gz root@$SSH_IP:/usr/
        if [[ $? -ne 0 ]]; then
            echo "deploy $package_name_service failed"
            echo "Please make sure connect with device before execute this script."
            exit 1
        fi

        result=$(ssh root@$SSH_IP "tar -zxf /usr/$package_name_service.tar.gz -C /usr/")
        if [[ $? -ne 0 ]]; then
            echo "deploy $package_name_service failed"
            echo "Please make sure connect with device before execute this script."
        elif [[ $result =~ "Error" ]]; then
            echo "deploy $package_name_service failed"
            echo "Please make sure QIRP is installed on device before execute this script."
        else
            echo "deploy $package_name_service successfully"
        fi
    else
        scp -i $SSH_KEY $package_name_service.tar.gz root@$SSH_IP:/usr/
        if [[ $? -ne 0 ]]; then
            echo "deploy $package_name_service failed"
            echo "Please make sure connect with device before execute this script."
            exit 1
        fi

        result=$(ssh -i $SSH_KEY root@$SSH_IP "tar -zxf /usr/$package_name_service.tar.gz -C /usr/")
        if [[ $? -ne 0 ]]; then
            echo "deploy $package_name_service failed"
            echo "Please make sure connect with device before execute this script."
        elif [[ $result =~ "Error" ]]; then
            echo "deploy $package_name_service failed"
            echo "Please make sure QIRP is installed on device before execute this script."
        else
            echo "deploy $package_name_service successfully"
        fi
    fi
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