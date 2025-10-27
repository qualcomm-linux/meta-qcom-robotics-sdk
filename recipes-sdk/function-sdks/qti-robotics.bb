inherit psdk-extract

#License applicable to the recipe file only,  not to the packages installed by this recipe.
LICENSE = "BSD-3-Clause-Clear"
PV = "1.0.0"
PR = "r0"

TARGET_SDK_PREFIX = "robotics"
SUMMARY          = "QCOM ROBOTICS SDK"
DESCRIPTION      = "QCOM ROBOTICS SDK"

# the information of function sdk package(s)
CONFIGFILE = "${@d.getVar('CONFIG_SELECT')}"
SDKSPATH = "${DEPLOY_DIR}/${TARGET_SDK_PREFIX}sdk_artifacts/${TARGET_SDK_PREFIX}-sdk_*.tar.gz"

FILES_SKIP = "${D}/${PN}/packages_oss \
              ${D}/${PN}/pathplan \
              "
do_fetch_extra[depends] += "packagegroup-qcom-robotics:do_generate_robotics_sdk"

RDEPENDS:${PN} = "packagegroup-qcom-robotics"

FILES:${PN} = " "
ALLOW_EMPTY:${PN} = "1"

SYSROOT_DIRS_IGNORE += "/${PN}/runtime"