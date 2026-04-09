FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_configure:append() {
    if [ -f ${B}/build.ninja ]; then
        sed -i -e 's/-Werror[^ ]*//g' ${B}/build.ninja
    fi
}
