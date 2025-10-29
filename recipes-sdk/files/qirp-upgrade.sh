#!/bin/bash

# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear


function main() {

    echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    echo ">>> upgrade qirp sdk"
    echo "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
    echo

    # This script
    THIS_SCRIPT=$(readlink -f ${BASH_SOURCE[0]})
    # Find where the script directory is...
    scriptdir="$(dirname "${THIS_SCRIPT}")"

    source $scriptdir/uninstall.sh
    source $scriptdir/install.sh
}

main "$@"
