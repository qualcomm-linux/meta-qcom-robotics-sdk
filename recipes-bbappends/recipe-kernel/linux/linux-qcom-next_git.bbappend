FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://configs/robotics-kernel.cfg"
SRC_URI += "file://0001-mm-page_alloc-Export-get_pfnblock_migratetype.patch"
SRC_URI += "file://0001-arm64-dts-qcom-lemans-evk-enable-UART0-for-robot-exp.patch"
SRC_URI += "file://0002-arm64-dts-qcom-monaco-evk-enable-UART6-for-robot-exp.patch"

# do_configure:prepend:append() {
#     #cat ${UNPACKDIR}/configs/robotics-kernel.cfg >> ${UNPACKDIR}/configs/qcom.cfg
#     ${S}/scripts/kconfig/merge_config.sh -m -O ${B} ${B}/.config ${UNPACKDIR}/configs/robotics-kernel.cfg
# }
KERNEL_CONFIG_COMMAND:prepend = "${S}/scripts/kconfig/merge_config.sh -m -O ${B} ${B}/.config ${UNPACKDIR}/configs/robotics-kernel.cfg;"