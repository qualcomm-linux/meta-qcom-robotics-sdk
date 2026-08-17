# lttng-modules 2.14.4 is incompatible with Linux kernel >= 7.1.
# The vmscan, shrink_slab, and hrtimer trace event APIs changed significantly
# in kernel 7.1 (commits f2e388a019e4, bd803783dfa7, and others).
# Exclude lttng-modules from the iq-9075-evk build which uses kernel 7.1.
LTTNGTOOLS:armv8-2a = "lttng-tools"

# Also remove from SDK RDEPENDS so do_populate_sdk does not trigger lttng-modules do_compile.
# BAD_RECOMMENDATIONS only suppresses rootfs installation; SDK packaging resolves RDEPENDS
# independently and would otherwise pull lttng-modules into the SDK dependency graph.
RDEPENDS:${PN}:remove:armv8-2a = "lttng-modules"