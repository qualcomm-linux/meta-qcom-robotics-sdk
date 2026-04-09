FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI:remove = "file://use-tinyxml-by-name.patch"

EXTRA_OECMAKE += "-Wno-error"

CXXFLAGS:append = " -I${STAGING_INCDIR}/pal_statistics -I${STAGING_INCDIR}/pal_statistics/pal_statistics"


FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_configure:append() {
    if [ -f ${B}/build.ninja ]; then
        sed -i -e 's/-Werror[^ ]*//g' ${B}/build.ninja
    fi
}

