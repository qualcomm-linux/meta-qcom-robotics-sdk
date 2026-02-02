CXXFLAGS += "-Wno-error=non-virtual-dtor -Wno-error=deprecated-declarations -Wno-error=shadow"

# Fix QA Issue [buildpaths]: CMake export files contain TMPDIR references
do_install:append() {
    # Clean up CMake export files to use relocatable paths
    if [ -d ${D}${ros_prefix}/share/${ROS_BPN}/cmake ]; then
        bbnote "Fixing CMake config files in ${D}${ros_prefix}/share/${ROS_BPN}/cmake"
        find ${D}${ros_prefix}/share/${ROS_BPN}/cmake -name '*.cmake' -type f | while read cmake_file; do
            bbnote "Processing: $cmake_file"
            
            # Directly replace STAGING_DIR_HOST + ros_prefix with ${_IMPORT_PREFIX}
            sed -i "s|${STAGING_DIR_HOST}${ros_prefix}|\${_IMPORT_PREFIX}|g" "$cmake_file"
        done
    fi
}