FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

# Fix build failure of "compatible with requested version range "1.9.7...<1.10.0"."
SRC_URI += "file://0001-build-set-octomap-version-to-1.11.0.patch"

# Fix QA Issue [buildpaths]: CMake export files contain TMPDIR references
# The correct approach is to use CMAKE_FIND_ROOT_PATH, not to strip STAGING_DIR_HOST
do_install:append() {
    # Clean up CMake export files to use relocatable paths
    if [ -d ${D}${ros_prefix}/share/${ROS_BPN}/cmake ]; then
        bbnote "Fixing CMake config files in ${D}${ros_prefix}/share/${ROS_BPN}/cmake"
        find ${D}${ros_prefix}/share/${ROS_BPN}/cmake -name '*.cmake' -type f | while read cmake_file; do
            bbnote "Processing: $cmake_file"

            # Directly replace STAGING_DIR_HOST + ros_prefix with ${_IMPORT_PREFIX}
            sed -i "s|${STAGING_DIR_HOST}${ros_prefix}|\${_IMPORT_PREFIX}|g" "$cmake_file"
            
            # Clean up any remaining STAGING_DIR_HOST references
            sed -i "s|${STAGING_DIR_HOST}||g" "$cmake_file"
            
            # # Remove absolute /usr paths for include directories (from host system)
            sed -i 's|/usr/include/eigen3;||g' "$cmake_file"
            sed -i 's|/usr/include;||g' "$cmake_file"

            # # Remove absolute /usr/lib paths - these will be found by CMake's find_library
            # # Pattern: /usr/lib/libXXX.so → libXXX.so (keep library name only)
            sed -i 's|/usr/lib/\(lib[^;"]*\.so[^;"]*\)|\1|g' "$cmake_file"
            sed -i 's|;/usr/lib;|;|g' "$cmake_file"
            sed -i 's|;/usr/lib"|;"|g' "$cmake_file"
        done
    fi
}