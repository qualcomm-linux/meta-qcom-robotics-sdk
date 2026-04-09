DEPENDS:append = " generate-parameter-library-native generate-parameter-library-py-native"

EXTRA_OECMAKE:append = " \
  -Dgenerate_parameter_library_cpp_BIN=${RECIPE_SYSROOT_NATIVE}${bindir}/generate_parameter_library_cpp \
"

do_configure:prepend() {
    export PYTHONPATH="${RECIPE_SYSROOT_NATIVE}${PYTHON_SITEPACKAGES_DIR}:$PYTHONPATH"
}

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_configure:append() {
    if [ -f ${B}/build.ninja ]; then
        sed -i -e 's/-Werror[^ ]*//g' ${B}/build.ninja
    fi
}

