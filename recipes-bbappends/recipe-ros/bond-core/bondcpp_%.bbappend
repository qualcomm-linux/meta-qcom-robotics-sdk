# Fix QA Issue [buildpaths]: CMake export files contain TMPDIR references
do_install:append() {
    # Clean up CMake export files to use relocatable paths
    if [ -d ${D}${ros_prefix}/share/${ROS_BPN}/cmake ]; then
        bbnote "Fixing CMake config files in ${D}${ros_prefix}/share/${ROS_BPN}/cmake"
        find ${D}${ros_prefix}/share/${ROS_BPN}/cmake -name '*.cmake' -type f | while read cmake_file; do
            bbnote "Processing: $cmake_file"
            
            # Clean up any remaining STAGING_DIR_HOST references
            sed -i "s|${STAGING_DIR_HOST}||g" "$cmake_file"

            sed -i 's|;/usr/include/uuid||g' "$cmake_file"
        done
    fi
}