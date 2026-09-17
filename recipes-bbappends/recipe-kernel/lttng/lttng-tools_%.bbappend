# lttng-modules 2.14.4+ is incompatible with the Linux kernel >= 7.1 used by
# iq-9075-evk (vmscan/shrink_slab/hrtimer trace event API changes).
#
# lttng-tools itself builds fine, but its -ptest package hard-RDEPENDS on
# ${LTTNGMODULES} (see recipes-kernel/lttng/lttng-tools_*.bb), which pulls
# lttng-modules back into the dependency graph and triggers its compile.
# BAD_RECOMMENDATIONS cannot help here because it only filters RRECOMMENDS,
# not RDEPENDS, so clear the variable to drop lttng-modules from every path
# (both the packagegroup RDEPENDS and the -ptest RDEPENDS).
LTTNGMODULES = ""
