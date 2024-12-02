inherit psdk-install
# License applies to this recipe code, not to the packages installed by this recipe
LICENSE          = "Qualcomm-Technologies-Inc.-Proprietary"
LIC_FILES_CHKSUM = "file://${QCOM_COMMON_LICENSE_DIR}/${LICENSE};md5=58d50a3d36f27f1a1e6089308a49b403"

SUMMARY          = "QNN-SDK"
DESCRIPTION      = "Qualcomm Neural Network SDK"

# the information of function sdk package(s)
CONFIGFILE = "${@d.getVar('CONFIG_SELECT')}"

# qnn-sdk should be downloaded before compiling this recipe,
# this recipe will unpack qnn-sdk zip, and pick up the files we needed.
QNPSDK_SRC_VER="2.27.0.240926"
QNPSDK_SRC_SHID="7bc0e6a642cd0281ab0337ad901024fb64a8960de1c848b1ca89f14e93ee35f8"
SRC_URI = "https://softwarecenter.qualcomm.com/api/download/software/qualcomm_neural_processing_sdk/v${QNPSDK_SRC_VER}.zip"
SRC_URI[sha256sum] = "${QNPSDK_SRC_SHID}"

QNN_DIR = "${WORKDIR}/qairt/${QNPSDK_SRC_VER}"
S = "${QNN_DIR}"
TARGET_SDK_PATH = "/usr"

do_unpack_qnn() {
    rm -rf ${S}_${PN}
    install -d "${S}_${PN}"
    mv ${S}/* "${S}_${PN}"
    install -d ${S}/${PN}
    mv ${S}_${PN}/* ${S}/${PN}
}
do_unpack[postfuncs] = "do_unpack_qnn"

do_install_qnn_pre(){
    bbnote "copy file from ${S}/${PN} ${D}_temp "
    cp -rf ${S}/${PN} ${D}_temp/
}
do_install_qnn_post(){
    bbnote "copy packages file from ${S}/${PN} ${D} "
    cp -rf ${S}/${PN} ${D}/
}
do_install_qnn_pre[dirs] = "${D}_temp"
do_install_qnn_pre[cleandir] = "${D}_temp"
do_install[prefuncs] = "do_install_qnn_pre"
do_install[postfuncs] = "do_install_qnn_post"

SYSROOT_DIRS = "/"
INSANE_SKIP:${PN} += "already-stripped installed-vs-shipped"
INHIBIT_SYSROOT_STRIP = "1"
EXCLUDE_FROM_SHLIBS = "1"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
INHIBIT_PACKAGE_STRIP = "1"

PACKAGES = "${PN} ${PN}-toolchain "

FILES:${PN} += " \
${TARGET_SDK_PATH}/lib/*.so* \
${TARGET_SDK_PATH}/include \
${TARGET_SDK_PATH}/lib/hexagon-v68/unsigned \
"

FILES:${PN}-toolchain = " \
${TARGET_SDK_PATH}/lib/x86_64-linux-clang \
"

do_package_qa[noexec] = "1"



