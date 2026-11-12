OVERRIDES:append = ":${PREFERRED_PROVIDER_virtual/kernel}"

# Keep the PV provided by the OE-Core recipe for normal kernels.
PV:linux-qcom-next = "2.16.0"

# Checksums:
#   2.14.7: checksum from the underlying OE-Core recipe
#   2.16.0: checksum of the upstream lttng-modules 2.16.0 release tarball
SRC_URI[sha256sum] = "${@ \
    '854600604cdaaa66fc1711e564aff37d8dbba9bd1d3aaa94f12a561da845deb9' \
    if d.getVar('PREFERRED_PROVIDER_virtual/kernel') == 'linux-qcom-next' \
    else \
    'fe304c31ad3e8f68a48f52b538ed2c1bf9b9fe62d8ee528ebc96d0a321287145'}"