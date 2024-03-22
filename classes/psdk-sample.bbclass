# Copyright (c) 2023-2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear

sync_sample_codes() {
    bbnote "downloading samples..."
    DOWNLOAD_SAMPLES_PATH="${QIRP_TOP_DIR}/sources/robotics/qirp-oss"
    #orgnanize sample codes
    if [ -d "${DOWNLOAD_SAMPLES_PATH}" ]; then
        bbnote "Sample path exists, removing: ${DOWNLOAD_SAMPLES_PATH}"
        rm -rf "${DOWNLOAD_SAMPLES_PATH}"
    fi

    install -d ${DOWNLOAD_SAMPLES_PATH%/*}
    cd ${DOWNLOAD_SAMPLES_PATH%/*}

    #get all sample code link and assign to LINK array
    tempfile=$(mktemp)
    echo "${SAMPLE_CODE_LINK}" | tr ' ' '\n' > $tempfile
    mapfile -t LINK < $tempfile

    #sync every sample git project
    for link in "${LINK[@]}"; do
        echo "$link"
        url=$(echo $link | cut -d';' -f1)
        branch=$(echo $link | cut -d';' -f2 | cut -d'=' -f2)
        git clone -b $branch $url
    done
}

do_install[postfuncs] += "check_and_sync_sample_codes"
python check_and_sync_sample_codes() {
    samples_path = d.getVar('SAMPLES_PATH')
    sample_code_link = d.getVar('SAMPLE_CODE_LINK')
    path_list = samples_path.split(" ")
    for path in path_list:
        if os.path.exists(path) and os.listdir(path) :
            bb.note("Get samples from SAMPLES_PATH")
    if sample_code_link:
        bb.note("Get samples from remote link")
        bb.build.exec_func('sync_sample_codes', d)
    else :
        bb.note("No samples found from both remote link and local path")
}



def check_sample_codes(d):
    samples_path = d.getVar('ROBOTICS_SAMPLES_PATH')
    if samples_path and os.path.exists(samples_path):
        bb.note("Get robotics samples from local path")
        return samples_path
    else :
        bb.note("No robotics samples found")
        return d.getVar('ROBOTICS_SAMPLE_CODE_LINK')

#SRC_URI += "${@check_sample_codes(d)}"
