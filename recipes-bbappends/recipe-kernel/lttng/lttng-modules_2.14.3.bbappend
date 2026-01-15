FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = "file://0002-fix-btrfs-headers-cleanup-to-remove-unnecessary-local-includes.patch \
            file://0003-fix-Manual-conversion-to-use-i_state-accessors-v6.19.patch "