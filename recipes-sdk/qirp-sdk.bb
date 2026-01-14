#License applicable to the recipe file only,  not to the packages installed by this recipe.
LICENSE = "BSD-3-Clause-Clear"

LIC_FILES_CHKSUM = " \
    file://${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear;md5=7a434440b651f4a472ca93716d01033a \
"
S = "${UNPACKDIR}"

inherit psdk-base psdk-package psdk-pickup

CONFIGFILE = "${@d.getVar('CONFIG_SELECT')}"
SRC_URI = "file://${@d.getVar('CONFIG_SELECT')}"
SRC_URI =+ "file://install.sh"
SRC_URI =+ "file://uninstall.sh"
SRC_URI =+ "file://qirp-setup.sh"
SRC_URI =+ "file://qirp-upgrade.sh"
SRC_URI =+ "file://samples.json"
SRC_URI =+ "file://qrb_ros_samples_scripts/"

# The path infos of qirp content
OSS_CHANNEL_FLAG = "${@bb.utils.contains_any('BBFILE_COLLECTIONS', 'qcom-robotics-extras', 'false', 'true', d)}"
TOOLCHAIN_PATH = "${DEPLOY_DIR}/sdk"
SETUP_PATH = "${FILE_DIRNAME}/files/setup.sh"

# The name and version of qirp SDK artifact
SDK_PN = "qirp-sdk"
PV = "2.4.0"

FILES:${PN} = "/usr/share/qirp-setup.sh"
FILES:${PN} += "/usr"
FILES:${PN} += "/usr/share"

DEPENDS:append = " \
    jq-native \
    git-native \
"

do_lic_install() {
    install -d ${LICENSE_DIRECTORY}/${SSTATE_PKGARCH}/${PN}
    install -m 0644 ${COMMON_LICENSE_DIR}/BSD-3-Clause-Clear \
        ${LICENSE_DIRECTORY}/${SSTATE_PKGARCH}/${PN}/generic_BSD-3-Clause-Clear
}
addtask lic_install after do_install before do_package