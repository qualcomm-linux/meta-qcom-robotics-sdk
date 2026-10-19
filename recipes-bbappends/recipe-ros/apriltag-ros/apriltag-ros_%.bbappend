CXXFLAGS:append = " -Wno-error=deprecated-declarations"

# apriltag-ros 3.4.0 already includes the tf2 convert.hpp change; remove the now-inapplicable patch from meta-ros
SRC_URI:remove = "file://0001-update-tf2-convert-header.patch"

RDEPENDS:${PN}:remove = "camera-ros"
