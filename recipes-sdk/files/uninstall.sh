#!/bin/bash
# Copyright (c) Qualcomm Technologies, Inc. and/or its subsidiaries.
# SPDX-License-Identifier: BSD-3-Clause-Clear

SDK_NAME="QIRP_SDK"
PKG_LIST_FILE="/usr/share/qirp-sdk/data/$SDK_NAME.list"

# Check if the script is run as root
function check_permission() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "ERROR: Root permission is required"
        exit 1
    fi
}

function main() {
    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo ">>> Uninstall script for $SDK_NAME"
    echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    echo

    check_permission

    # Check if the package list file exists
    if [ ! -f "$PKG_LIST_FILE" ]; then
        echo "ERROR: $SDK_NAME is not installed"
        exit 1
    fi

    # Determine the uninstall command based on the OS
    if lsb_release -a 2>/dev/null | grep -q "Ubuntu"; then
        uninstall_command="dpkg -r --force-depends"
    else
        uninstall_command="opkg remove --force-depends --force-remove"
    fi

    # Read all package names into an array
    mapfile -t REMOVE_PKGS < "$PKG_LIST_FILE"

    # Uninstall all packages in one command
    if [ ${#REMOVE_PKGS[@]} -eq 0 ]; then
        echo "No packages to remove."
    else
        echo "Removing packages: ${REMOVE_PKGS[*]}"
        $uninstall_command "${REMOVE_PKGS[@]}"
    fi
    # Remove the package list file
    rm -f "$PKG_LIST_FILE"
    echo "Uninstallation complete."
}

main "$@"

