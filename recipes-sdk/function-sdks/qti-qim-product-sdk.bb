inherit psdk-extract

#License applicable to the recipe file only,  not to the packages installed by this recipe.
LICENSE = "BSD-3-Clause-Clear"

COPY_PACKAGES = "0"

# the information of function sdk package(s)
CONFIGFILE = "${@d.getVar('CONFIG_SELECT')}"
SDKSPATH = "${DEPLOY_DIR}/qim_prod_sdk_artifacts/qim-prod-sdk_*.tar.gz"

do_fetch_extra[depends] += "${@bb.utils.contains_any('BBFILE_COLLECTIONS', 'qcom-qim-product-sdk', 'qim-product-sdk:do_generate_qim_prod_sdk', '', d)}"

# Build sstate cache is old, so disable incremental build in internal
# Not include in external layer, this flag is set for internal only.
do_fetch_extra[nostamp] = "1"

SYSROOT_DIRS_IGNORE += "/${PN}/runtime"

# skip unnecessary ipk/deb packages
PKGS_SKIP = "qcom-qnn-sdk \
             qcom-qnn-sdk-dev \
             qcom-qnn-sdk-dbg \
             qcom-snpe-sdk \
             qcom-snpe-sdk-dev \
             qcom-snpe-sdk-dbg \
             libgomp-dev \
"

SKIP_OTHERS = " libgomp-dev \
             lame \
             liba52-0 \
             libgdk-pixbuf-2.0-0 \
             libgomp-dev \
             libgudev-1.0-0 \
             libhiredis1.0.0 \
             libjson-glib-1.0-0 \
             libmosquitto1 \
             libmp3lame0 \
             libnice \
             liborc-0.4-0 \
             libpsl5 \
             librsvg-2-2 \
             libsbc1 \
             libsoup-2.4 \
             libspeex1 \
             libsrt1.4 \
             libsrtp2-1 \
             libtag1 \
             libtheora \
             libwebp \
             mpg123 \ 
"
PACKAGES = "${PN}"
FILES:${PN} = "${libdir}/qim/* /usr/libexec/qim/* /usr/bin/qim/*"