# ERROR: osqp-vendor-0.2.0-4-r0 do_fetch: Fetcher failure: Unable to find revision dd3878565d2be8dcd2b23e76a08e95b1d2baf89f in branch 
# release/jazzy/osqp_vendor even from upstream
SRCREV_release = "581a58b5467b5dcdca551e613b4bb1e4d47e30e0"

# Fix destsuffix to place osqp-upstream in the correct location for CMake
# meta-ros uses destsuffix=git/osqp-upstream, but CMakeLists.txt expects it at ${CMAKE_SOURCE_DIR}/osqp-upstream
# We need to override the SRC_URI to fix the path
FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"
SRC_URI = " \
    git://github.com/ros2-gbp/osqp_vendor-release;name=release;${ROS_BRANCH};protocol=https \
    file://0002-CMakeLists.txt-fetch-osqp-with-bitbake-fetcher.patch \
    git://github.com/oxfordcontrol/osqp.git;protocol=https;name=osqp;destsuffix=osqp-vendor-${PV}/osqp-upstream;branch=master \
    git://github.com/oxfordcontrol/qdldl.git;protocol=https;name=qdldl;destsuffix=osqp-vendor-${PV}/osqp-upstream/lin_sys/direct/qdldl/qdldl_sources;branch=master \
    file://0001-fix-set-cmake-minimum-version-to-3.5.patch;patchdir=osqp-upstream/lin_sys/direct/qdldl/qdldl_sources \
    file://0002-fix-set-cmake-minimum-version-to-3.5.patch;patchdir=osqp-upstream \
"

# Keep the SRCREV values from meta-ros
SRCREV_osqp = "f9fc23d3436e4b17dd2cb95f70cfa1f37d122c24"
SRCREV_qdldl = "7d16b70a10a152682204d745d814b6eb63dc5cd2"
SRCREV_FORMAT = "release_osqp_qdldl"

EXTRA_OECMAKE += "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"