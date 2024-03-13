inherit psdk-extract

# License applies to this recipe code, not to the packages installed by this recipe
LICENSE = "BSD-3-clause-clear"

# the information of function sdk package(s)
CONFIGFILE = "${@d.getVar('CONFIG_SELECT')}"
SDKSPATH = "${QIRP_TOP_DIR}/function-sdk/qim-sdk/packages.zip"

# skip unnecessary ipk/deb packages
PKGS_SKIP = "qnn \
             qnn-dev \
            "
