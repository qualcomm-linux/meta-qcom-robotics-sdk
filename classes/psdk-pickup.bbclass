# Copyright (c) 2023-2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

python do_install () {
    import os
    import json
    from pathlib import Path
    import glob
    import subprocess
    outputdir = d.getVar('D')
    # move setup script to /usr/share dir
    SETUP_DEST_PATH="/usr/share/"
    SETUP_SCRIPT_FILE="qirp-setup.sh"
    cp_cmd = "mkdir -p %s && cp %s %s" %(outputdir + SETUP_DEST_PATH, d.getVar('WORKDIR') + "/" + SETUP_SCRIPT_FILE, outputdir + SETUP_DEST_PATH)
    bb.note(cp_cmd)
    subprocess.call(cp_cmd,shell=True)
}
