# Repair the pal_statistics path to solve compile build problems
do_install:append() {
    if [ -d "${D}${ros_prefix}/include/pal_statistics/pal_statistics" ]; then
        bbnote "Fixing pal_statistics header install layout"
        install -d "${D}${ros_prefix}/include/pal_statistics"
        cp -af "${D}${ros_prefix}/include/pal_statistics/pal_statistics/." \
               "${D}${ros_prefix}/include/pal_statistics/"
    fi
}

