SRC_URI:remove = "file://0001-CMakeLists.txt-allow-to-set-PY_DEST.patch"

do_configure:append() {
    if [ -f ${B}/build.ninja ]; then
        sed -i -e 's/-Werror[^ ]*//g' ${B}/build.ninja
    fi
}
