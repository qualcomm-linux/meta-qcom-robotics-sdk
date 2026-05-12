FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://configs/robotics-kernel.cfg"

# do_configure:prepend:append() {
#     #cat ${UNPACKDIR}/configs/robotics-kernel.cfg >> ${UNPACKDIR}/configs/qcom.cfg
#     ${S}/scripts/kconfig/merge_config.sh -m -O ${B} ${B}/.config ${UNPACKDIR}/configs/robotics-kernel.cfg
# }
KERNEL_CONFIG_COMMAND:prepend = "${S}/scripts/kconfig/merge_config.sh -m -O ${B} ${B}/.config ${UNPACKDIR}/configs/robotics-kernel.cfg;"
