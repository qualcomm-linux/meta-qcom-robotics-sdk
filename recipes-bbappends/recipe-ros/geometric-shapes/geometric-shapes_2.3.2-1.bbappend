FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

# Fix build failure of "compatible with requested version range "1.9.7...<1.10.0"."
SRC_URI += "file://0001-build-set-octomap-version-to-1.11.0.patch"