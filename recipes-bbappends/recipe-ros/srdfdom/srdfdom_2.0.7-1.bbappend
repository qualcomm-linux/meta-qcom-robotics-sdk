# setuptools_scm in native sysroot tries to run 'hg root' during egg_info,
# which hangs in the Yocto sandbox. Pretend the version to skip VCS detection.
export SETUPTOOLS_SCM_PRETEND_VERSION = "${PV}"
