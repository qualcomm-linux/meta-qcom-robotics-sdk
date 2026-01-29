# Allow FetchContent to download Foxglove SDK from GitHub
# By default, Yocto sets FETCHCONTENT_FULLY_DISCONNECTED=ON to prevent network access during configure
# But foxglove-bridge needs to download the pre-compiled SDK
EXTRA_OECMAKE += " \
    -DFETCHCONTENT_FULLY_DISCONNECTED=OFF \
"
CXXFLAGS += "-Wno-error=old-style-cast"