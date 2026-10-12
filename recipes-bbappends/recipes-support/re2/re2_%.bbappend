# Copyright (c) 2026 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
#
# The robotics eSDK (do_sdk_depends / do_populate_sdk_ext) stages the entire
# recursive dependency closure into a single recipe-sysroot. re2 enables ptest
# via the distro-default "ptest" DISTRO_FEATURE, which pulls meta-oe's
# googlebenchmark into that closure. googlebenchmark and meta-ros's
# google-benchmark (required by google-benchmark-vendor and the ROS stack) are
# two recipes built from the same upstream, and both stage an identical
# usr/include/benchmark/benchmark.h. In the shared SDK sysroot they collide,
# failing do_sdk_depends with:
#   FileExistsError: ... /recipe-sysroot/usr/include/benchmark/benchmark.h
#
# re2 ptest is not needed in the SDK, and disabling it drops googlebenchmark
# from the closure, leaving google-benchmark as the sole provider.
PTEST_ENABLED = "0"
