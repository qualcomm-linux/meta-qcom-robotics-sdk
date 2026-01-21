FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"
SRC_URI += " \
    file://0001-fix-set-octomap-maximum-version-to-1.11.0.patch \
    file://0002-remove-boost-system-dependency.patch \
"