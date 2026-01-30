LICENSE = "BSD-3-Clause-Clear"

SRC_URI = "file://qirp-setup.sh"
SRC_URI =+ "file://LICENSE.txt"

LIC_FILES_CHKSUM = " \
    file://LICENSE.txt;md5=2998c54c288b081076c9af987bdf4838 \
"

S = "${UNPACKDIR}"
# Run-time dependent scripts are used to configure the system runtime environment.
FILES:${PN} = "/usr/share/qirp-setup.sh"

# Conditional RDEPENDS based on image type
python () {
    pn = d.getVar("PN")
    image_basename = d.getVar("IMAGE_BASENAME")
    
    # Check if we're building for a proprietary image
    # First check IMAGE_BASENAME
    is_proprietary = False
    if image_basename and "proprietary" in image_basename:
        is_proprietary = True
        bb.note("qirp-sdk: Detected proprietary image from IMAGE_BASENAME: %s" % image_basename)
    
    if is_proprietary:
        # Proprietary image: depend on three packagegroups
        d.appendVar('RDEPENDS:' + pn, ' packagegroup-robotics-opensource')
        d.appendVar('RDEPENDS:' + pn, ' packagegroup-oss-with-prop-deps')
        d.appendVar('RDEPENDS:' + pn, ' packagegroup-robotics-proprietary')
        bb.note("qirp-sdk: Adding RDEPENDS for proprietary image (3 packagegroups)")
    else:
        # Open-source image (or no image context): depend on one packagegroup
        # This handles:
        # 1. qcom-robotics-image (open-source)
        # 2. No image context (compiling qirp-sdk or packagegroup directly)
        # 3. Any other image without "proprietary" in the name
        d.appendVar('RDEPENDS:' + pn, ' packagegroup-robotics-opensource')
        if image_basename:
            bb.note("qirp-sdk: Adding RDEPENDS for open-source image: %s (1 packagegroup)" % image_basename)
        else:
            bb.note("qirp-sdk: Adding RDEPENDS for default open-source image (no image context, 1 packagegroup)")
}

do_install() {
    install -d ${D}/usr/share
    install -m 0755 ${UNPACKDIR}/qirp-setup.sh ${D}/usr/share/qirp-setup.sh
}

do_lic_install() {
    install -d ${LICENSE_DIRECTORY}/${SSTATE_PKGARCH}/${PN}
    install -m 0644 ${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear \
        ${LICENSE_DIRECTORY}/${SSTATE_PKGARCH}/${PN}/generic_BSD-3-Clause-Clear
}
addtask lic_install after do_install before do_package