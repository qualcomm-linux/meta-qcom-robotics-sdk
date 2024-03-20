inherit psdk-extract

#License applicable to the recipe file only,  not to the packages installed by this recipe.
LICENSE = "BSD-3-Clause-Clear"

# the information of function sdk package(s)
CONFIGFILE = "${@d.getVar('CONFIG_SELECT')}"
SDKSPATH = "${DEPLOY_DIR}/qirfsdk_artifacts/qirf-sdk_*.tar.gz"

FILES_SKIP = "${D}/${PN}/packages_oss \
              ${D}/${PN}/pathplan \
              "
do_fetch_extra[depends] += "qirf-sdk:do_generate_robotics_sdk"

SYSROOT_DIRS_IGNORE += "/${PN}/runtime"
