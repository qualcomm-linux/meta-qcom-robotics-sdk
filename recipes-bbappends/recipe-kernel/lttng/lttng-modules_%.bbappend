FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# lttng-modules 2.14.4 is incompatible with Linux kernel >= 7.1 due to API
# changes in hrtimer, vmscan, shrink_slab, and other trace events.
# The iq-9075-evk uses kernel 7.1. Override compile and install to produce
# empty packages so the image build can proceed without lttng kernel modules.
do_compile() {
    bbwarn "lttng-modules compile skipped: not compatible with kernel 7.1"
}

do_install() {
    install -d ${D}
}

ALLOW_EMPTY:${PN} = "1"
ALLOW_EMPTY:${PN}-dev = "1"
ALLOW_EMPTY:${PN}-dbg = "1"
ALLOW_EMPTY:${PN}-staticdev = "1"
PACKAGES = "${PN} ${PN}-dev ${PN}-dbg ${PN}-staticdev"
