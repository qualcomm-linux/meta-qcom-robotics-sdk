# Kernel 6.18+ ships scripts/mksysmap with the interpreter line
# '#!/bin/sed -f'. When kernel-devsrc is packaged, RPM turns that shebang
# into a hard 'Requires: /bin/sed' file dependency. On a merged-usr rootfs
# sed is installed at /usr/bin/sed (and in the QIRP SDK target set it is
# provided by busybox via update-alternatives, not by a standalone 'sed'
# package), so nothing packages the literal path /bin/sed. DNF 4 does not
# load filelists metadata by default and cannot satisfy the dependency,
# which breaks do_populate_sdk / rootfs assembly with:
#   nothing provides /bin/sed needed by kernel-devsrc
#
# The upstream recipe already normalises python/awk interpreters in these
# scripts for exactly this reason (the scripts are shipped as sources and
# are not executed from the devsrc tree). Extend that normalisation to sed
# so the generated dependency resolves to /usr/bin/env, which is always
# available.
do_install:append() {
    kerneldir=${D}${KERNEL_BUILD_ROOT}${KERNEL_VERSION}
    for ss in $(find $kerneldir/build/scripts -type f); do
        sed -i '1s,^#!/bin/sed,#!/usr/bin/env sed,' "$ss"
    done
}
