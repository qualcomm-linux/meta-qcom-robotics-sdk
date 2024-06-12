# License applies to this recipe code, not to the packages installed by this recipe
LICENSE          = "Qualcomm-Technologies-Inc.-Proprietary"
LIC_FILES_CHKSUM = "file://${QCOM_COMMON_LICENSE_DIR}/${LICENSE};md5=58d50a3d36f27f1a1e6089308a49b403"

SUMMARY          = "QNN-SDK"
DESCRIPTION      = "Qualcomm Neural Network SDK"

# the information of function sdk package(s)
CONFIGFILE = "${@d.getVar('CONFIG_SELECT')}"

# qnn-sdk should be downloaded before compiling this recipe,
# this recipe will unpack qnn-sdk zip, and pick up the files we needed.
QNPSDK_SRC_VER="2.22.0.240425"
QNPSDK_SRC_SHID="d68ed4d92187101a9759384cbce0a35bd383840b2e3c3c746a4d35f99823a75a"
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