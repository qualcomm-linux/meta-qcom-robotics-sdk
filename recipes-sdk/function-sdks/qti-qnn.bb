inherit psdk-extract

# License applies to this recipe code, not to the packages installed by this recipe
LICENSE = "BSD-3-clause-clear"

# the information of function sdk package(s)
CONFIGFILE = "${@d.getVar('CONFIG_SELECT')}"

# qnn-sdk should be downloaded before compiling this recipe,
# this recipe will unpack qnn-sdk zip, and pick up the files we needed.
SDKSPATH = "${@bb.utils.contains_any('BBFILE_COLLECTIONS', 'qcom-qim-product-sdk', '${DL_DIR}/qnn/', '${QIRP_TOP_DIR}/function-sdk/qnn-sdk/qnn-sdk*.zip', d)}"

do_fetch_extra[depends] += "${@bb.utils.contains_any('BBFILE_COLLECTIONS', 'qcom-qim-product-sdk', 'qnn:do_fetch', '', d)}"