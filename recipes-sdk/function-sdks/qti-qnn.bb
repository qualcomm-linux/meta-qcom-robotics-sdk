# License applies to this recipe code, not to the packages installed by this recipe
LICENSE          = "Qualcomm-Technologies-Inc.-Proprietary"
LIC_FILES_CHKSUM = "file://${QCOM_COMMON_LICENSE_DIR}/${LICENSE};md5=58d50a3d36f27f1a1e6089308a49b403"

SUMMARY          = "QNN-SDK"
DESCRIPTION      = "Qualcomm Neural Network SDK"

# the information of function sdk package(s)
CONFIGFILE = "${@d.getVar('CONFIG_SELECT')}"

# qnn-sdk should be downloaded before compiling this recipe,
# this recipe will unpack qnn-sdk zip, and pick up the files we needed.
QNPSDK_SRC_VER="2.22.10.240618"
QNPSDK_SRC_SHID="06ba9d28252299207d5d0a5d05d7b26f122fac34d2f904b656732242678ef119"
SRC_URI = "https://softwarecenter.qualcomm.com/api/download/software/qualcomm_neural_processing_sdk/v${QNPSDK_SRC_VER}.zip"
SRC_URI[sha256sum] = "${QNPSDK_SRC_SHID}"

QNN_DIR = "${WORKDIR}/qairt/${QNPSDK_SRC_VER}"

do_install() {
    install -d ${D}/${PN}

    cp -r ${QNN_DIR}/* ${D}/${PN}/
    chmod -R 0755 ${D}/${PN}
}

SYSROOT_DIRS = "/"
FILES:${PN} = " "
ALLOW_EMPTY:${PN} = "1"
INSANE_SKIP:${PN} += "already-stripped installed-vs-shipped"
INHIBIT_SYSROOT_STRIP = "1"
EXCLUDE_FROM_SHLIBS = "1"