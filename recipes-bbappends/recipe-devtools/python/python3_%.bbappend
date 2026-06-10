# python3 3.14+ generates _sysconfig_vars_*.json that embeds the build TMPDIR
# in the "userbase" field.  Skip the buildpaths QA check for python3.
INSANE_SKIP:${PN}-misc += "buildpaths"
