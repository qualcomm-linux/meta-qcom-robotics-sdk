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

# Include ${MACHINE} to avoid sstate manifest conflicts across machines
PACKAGEGROUP_LIST_DIR = "${DEPLOY_DIR}/packagegroup-lists/${MACHINE}"
# add private staging
PACKAGEGROUP_LIST_STAGING_DIR = "${WORKDIR}/packagegroup-lists-staging"

# register sstate tasks
SSTATETASKS += "do_collect_rdepends"
# task write to private staging dir
do_collect_rdepends[sstate-inputdirs] = "${PACKAGEGROUP_LIST_STAGING_DIR}"
# recover from sstate dir
do_collect_rdepends[sstate-outputdirs] = "${PACKAGEGROUP_LIST_DIR}"

# Add task: collect RDEPENDS after packagegroup build
addtask do_collect_rdepends after do_package_write before do_build
# Use RDEPENDS:${PN} so hash changes when per-package deps change
do_collect_rdepends[vardeps] = "RDEPENDS:${PN}"

# Function: do_collect_rdepends
# Collect direct runtime dependencies from the current packagegroup and write
# them into ${PACKAGEGROUP_LIST_DIR}/${PN}.list for later SDK packaging use.
python do_collect_rdepends() {
    import os

    pn = d.getVar("PN")

    bb.note("Collecting RDEPENDS for packagegroup: {}".format(pn))

    # Get RDEPENDS — use explode_deps to correctly strip version constraints
    rdepends_raw = d.getVar("RDEPENDS:{}".format(pn)) or ""

    if not rdepends_raw:
        bb.warn("RDEPENDS for {} is empty (will be added later)".format(pn))

    # explode_deps returns a list of bare package names, version constraints removed
    packages = bb.utils.explode_deps(rdepends_raw)

    # Write to private staging dir instead of DEPLOY_DIR
    list_dir = d.getVar("PACKAGEGROUP_LIST_STAGING_DIR")
    os.makedirs(list_dir, exist_ok=True)

    list_file = os.path.join(list_dir, "{}.list".format(pn))

    # Remove old list file before creating new one to ensure a fresh result
    if os.path.exists(list_file):
        bb.note("Removing old list file: {}".format(list_file))
        os.remove(list_file)

    with open(list_file, 'w') as f:
        for pkg in packages:
            f.write("{}\n".format(pkg))

        # The qirp-sdk, as a separate main package, needs to be included in all images.
        # Please refer to qirp-sdk.bb
        f.write("{}\n".format("qirp-sdk"))

    bb.note("Wrote {} packages to {}".format(len(packages), list_file))
}

# Function: do_clean_rdepends
# Remove only this recipe's generated list file during cleanall so stale
# package lists are not reused by later builds.
addtask do_clean_rdepends before do_cleanall

do_clean_rdepends() {
    rm -f ${PACKAGEGROUP_LIST_DIR}/${PN}.list
    rm -f ${PACKAGEGROUP_LIST_STAGING_DIR}/${PN}.list
}
