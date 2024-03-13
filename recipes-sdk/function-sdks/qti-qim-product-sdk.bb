inherit psdk-extract

#License applicable to the recipe file only,  not to the packages installed by this recipe.
LICENSE = "BSD-3-Clause-Clear"

# the information of function sdk package(s)
CONFIGFILE = "${@d.getVar('CONFIG_SELECT')}"
SDKSPATH = "${DEPLOY_DIR}/qim_prod_sdk_artifacts/qim-prod-sdk_*.tar.gz"

do_fetch_extra[depends] += "${@bb.utils.contains_any('BBFILE_COLLECTIONS', 'qcom-qim-product-sdk', 'qim-product-sdk:do_generate_qim_prod_sdk', '', d)}"

SYSROOT_DIRS_IGNORE += "/${PN}/runtime"
