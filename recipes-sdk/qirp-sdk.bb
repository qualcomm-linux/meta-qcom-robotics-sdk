LICENSE = "BSD-3-Clause-Clear"

SRC_URI = "file://qirp-setup.sh"

S = "${UNPACKDIR}"
# Run-time dependent scripts are used to configure the system runtime environment.
FILES:${PN} = "/usr/share/qirp-setup.sh"

do_install() {
    install -d ${D}/usr/share
    install -m 0755 ${UNPACKDIR}/qirp-setup.sh ${D}/usr/share/qirp-setup.sh
}