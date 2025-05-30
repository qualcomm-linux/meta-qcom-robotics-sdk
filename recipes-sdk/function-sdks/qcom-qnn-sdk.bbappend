do_install:append(){
    install -d ${D}/${libdir}/python/qti
    install -d ${D}/lib/x86_64-linux-clang
    install -d ${D}/bin/x86_64-linux-clang

    install -m 0755 ${QNN_DIR}/bin/envsetup.sh ${D}/${bindir}
    install -m 0755 ${QNN_DIR}/bin/envcheck ${D}/${bindir}
    install -m 0755 ${QNN_DIR}/bin/check-python-dependency ${D}/${bindir}
    install -m 0755 ${QNN_DIR}/bin/${PLATFORM_DIR}/genie-* ${D}/${bindir}

    cp -r ${QNN_DIR}/include/Genie/* ${D}/${includedir}

    cp -r ${QNN_DIR}/lib/python/qti/* ${D}/${libdir}/python/qti
    cp -r ${QNN_DIR}/lib/hexagon-v66/* ${D}/${libdir}
    cp -r ${QNN_DIR}/lib/hexagon-v68/* ${D}/${libdir}
    cp -r ${QNN_DIR}/lib/hexagon-v69/* ${D}/${libdir}
    cp -r ${QNN_DIR}/lib/hexagon-v73/* ${D}/${libdir}
    cp -r ${QNN_DIR}/lib/hexagon-v75/* ${D}/${libdir}

    chmod -R 0755 ${D}/${libdir}
    chmod -R 0755 ${D}/${libdir}/python/qti

    #install QNN toolchain
    cp -r ${QNN_DIR}/lib/x86_64-linux-clang/* ${D}/lib/x86_64-linux-clang
    chmod -R 0755 ${D}/lib/x86_64-linux-clang
    cp -r ${QNN_DIR}/bin/x86_64-linux-clang/* ${D}/bin/x86_64-linux-clang
    chmod -R 0755 ${D}/bin/x86_64-linux-clang
}

do_fix_hexagon(){
    cd ${D}/${libdir}
    ln -sf ./hexagon-v73/unsigned/libQnnHtpV73.so libQnnHtpV73.so
    ln -sf ./hexagon-v73/unsigned/libQnnHtpV73Skel.so libQnnHtpV73Skel.so
}
do_install[postfuncs] += "do_fix_hexagon"

PACKAGES += " ${PN}-toolchain "

RDEPENDS:${PN} += " ${PN}-dev "

FILES:${PN}-toolchain = " \
/lib/x86_64-linux-clang \
/bin/x86_64-linux-clang \
"

FILES:${PN} += " \
${libdir}/python/qti \
${libdir}/hexagon-v* \
"