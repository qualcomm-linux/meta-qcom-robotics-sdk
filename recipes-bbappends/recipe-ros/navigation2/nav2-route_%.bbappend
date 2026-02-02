CXXFLAGS += "-Wno-error=deprecated-declarations -Wno-error=non-virtual-dtor -Wno-error=shadow"

# Fix QA Issue [buildpaths]: CMake export files contain TMPDIR references
do_install:append() {
    # Clean up CMake export files to use relocatable paths
    if [ -d ${D}${ros_prefix}/share/${ROS_BPN}/cmake ]; then
        bbnote "Fixing CMake config files in ${D}${ros_prefix}/share/${ROS_BPN}/cmake"
        find ${D}${ros_prefix}/share/${ROS_BPN}/cmake -name '*.cmake' -type f | while read cmake_file; do
            bbnote "Processing: $cmake_file"

            # Step 1: Replace STAGING_DIR_HOST + ros_prefix with ${_IMPORT_PREFIX}
            # This makes the package's own paths relocatable
            sed -i "s|${STAGING_DIR_HOST}${ros_prefix}|\${_IMPORT_PREFIX}|g" "$cmake_file"

            # Step 2: Replace remaining STAGING_DIR_HOST with ${CMAKE_SYSROOT}
            # This makes dependency paths work in cross-compilation
            # ${CMAKE_SYSROOT} will point to the consuming package's sysroot
            sed -i "s|${STAGING_DIR_HOST}|\${CMAKE_SYSROOT}|g" "$cmake_file"
        done
    fi
}