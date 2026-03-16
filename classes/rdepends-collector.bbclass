# Copyright (c) 2025 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
#
# rdepends-collector.bbclass
# Purpose:
#   Collects direct RDEPENDS from a packagegroup recipe and writes the result
#   into PACKAGEGROUP_LIST_DIR as a plain package list file.
#
# Main responsibilities:
#   1. Add a do_collect_rdepends task after package output is generated.
#   2. Read the packagegroup's direct runtime dependencies.
#   3. Write one package name per line into a deploy-side list file.
#   4. Always append qirp-sdk so the SDK package is included in generated images.
#   5. Remove generated list files during cleanup.
#
# Relationship to other classes:
#   The generated *.list files are consumed by psdk-image.bbclass when it
#   collects runtime packages for the final QIRP SDK archive.

PACKAGEGROUP_LIST_DIR = "${DEPLOY_DIR}/packagegroup-lists"

# Add task: collect RDEPENDS after packagegroup build
addtask do_collect_rdepends after do_package_write before do_build
do_collect_rdepends[vardeps] = "RDEPENDS"

# Function: do_collect_rdepends
# Collect direct runtime dependencies from the current packagegroup and write
# them into ${PACKAGEGROUP_LIST_DIR}/${PN}.list for later SDK packaging use.
python do_collect_rdepends() {
    """
    Collect packagegroup RDEPENDS and write to file
    Only collects direct RDEPENDS, not dependencies of dependencies
    """
    import os
    
    d = d  # bitbake data object
    pn = d.getVar("PN")
    
    bb.note("Collecting RDEPENDS for packagegroup: {}".format(pn))
    
    # Get RDEPENDS
    rdepends_var = 'RDEPENDS:{}'.format(pn)
    rdepends = d.getVar(rdepends_var, True) or ""
    
    if not rdepends:
        bb.warn("RDEPENDS for {} is empty (will be added later)".format(pn))
        # Create file even if empty, so content can be added later
        rdepends = ""
    
    # Create directory
    list_dir = d.getVar("PACKAGEGROUP_LIST_DIR")
    os.makedirs(list_dir, exist_ok=True)
    
    # Write to file
    list_file = os.path.join(list_dir, "{}.list".format(pn))
    
    # Remove old list file before creating new one
    # This ensures we start fresh each time
    if os.path.exists(list_file):
        bb.note("Removing old list file: {}".format(list_file))
        os.remove(list_file)
    
    with open(list_file, 'w') as f:
        # One package per line, remove whitespace
        for pkg in rdepends.split():
            pkg_clean = pkg.strip()
            if pkg_clean:
                f.write("{}\n".format(pkg_clean))
        
        # The qirp-sdk, as a separate main package, needs to be included in all images. Please refer to qirp-sdk.bb
        f.write("{}\n".format("qirp-sdk"))

    package_count = len(rdepends.split())
    bb.note("Wrote {} packages to {}".format(package_count, list_file))
}

# Function: do_clean_rdepends
# Remove the generated dependency list directory during cleanall so stale
# package lists are not reused by later builds.
# Cleanup task
addtask do_clean_rdepends before do_cleanall

do_clean_rdepends() {
    rm -rf ${PACKAGEGROUP_LIST_DIR}
}
