FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

# Fix QA Issue [buildpaths]: CMake export files contain TMPDIR references
do_install:append() {
    # CMake 4.3.1 strictly validates INTERFACE_LINK_LIBRARIES at generate time.
    # moveit_coreTargetsExport.cmake references Bullet::BulletCollision, but
    # ament_cmake_export_dependencies calls find_package(Bullet) without CONFIG,
    # so FindBullet.cmake (module mode) runs and only sets BULLET_* variables —
    # Bullet::* imported targets are never created. Prepend a CONFIG-mode call so
    # BulletConfig.cmake loads first and creates the imported targets before the
    # targets export file is processed by any downstream consumer.
    deps_cmake="${D}${ros_prefix}/share/${ROS_BPN}/cmake/ament_cmake_export_dependencies-extras.cmake"
    if [ -f "$deps_cmake" ]; then
        sed -i 's/^if(NOT _exported_dependencies STREQUAL "")/find_package(Bullet CONFIG QUIET)\nif(NOT _exported_dependencies STREQUAL "")/' "$deps_cmake"
    fi

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