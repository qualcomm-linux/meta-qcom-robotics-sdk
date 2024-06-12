#License applicable to the recipe file only,  not to the packages installed by this recipe.
LICENSE = "BSD-3-Clause-Clear"

inherit psdk-base psdk-package psdk-pickup

CONFIGFILE = "${@d.getVar('CONFIG_SELECT')}"
SRC_URI = "file://${@d.getVar('CONFIG_SELECT')}"
SRC_URI =+ "file://install.sh"
SRC_URI =+ "file://uninstall.sh"
SRC_URI =+ "file://qirp-setup.sh"
SRC_URI =+ "file://qirp-upgrade.sh"

# The path infos of qirp content
OSS_CHANNEL_FLAG = "${@bb.utils.contains_any('BBFILE_COLLECTIONS', 'qcom-robotics-extras', 'false', 'true', d)}"
TOOLCHAIN_PATH = "${DEPLOY_DIR}/sdk"
SETUP_PATH = "${FILE_DIRNAME}/files/setup.sh"

# The name and version of qirp SDK artifact
SDK_PN = "qirp-sdk"
PV = "2.1.0"

# The functionality of qirp SDK
DEPENDS += "jq-native git-native"
DEPENDS += "${@bb.utils.contains_any('MACHINE', 'qcm6490', 'qti-qirf', "", d)}"
DEPENDS += "${@bb.utils.contains_any('MACHINE', 'qcm6490', 'qti-qnn', "", d)}"
DEPENDS += "${@bb.utils.contains_any('MACHINE', 'qcm6490', 'qti-qim-product-sdk', "", d)}"

# The runtime dependency for qirp sdk sample
RDEPENDS:${PN} = "qirf-sdk"
