# gsx-in-the-wild-4.vmx is parser test data containing
# "#!/usr/bin/vmware". It is not executed by libvirt-ptest,
# but file-rdeps treats the shebang as a runtime dependency.
INSANE_SKIP:libvirt-ptest += "file-rdeps"
