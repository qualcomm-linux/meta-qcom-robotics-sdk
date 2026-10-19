FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

# foxglove-bridge 3.5.0+ uses FetchContent to download a prebuilt Foxglove SDK zip during
# configure. Pre-fetch the zip via SRC_URI and patch CMakeLists.txt to redirect FetchContent
# to the local file. Then pass foxglove-sdk_DIR explicitly because Yocto's toolchain sets
# CMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY, which prevents find_package from seeing _deps/.
EXTRA_OECMAKE += "-DFETCHCONTENT_FULLY_DISCONNECTED=OFF"

# Yocto sets CMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ONLY, which prevents find_package from
# searching outside the sysroot — including FetchContent's _deps directory. Override
# foxglove-sdk_DIR explicitly so CMake skips the search and uses the extracted SDK directly.
EXTRA_OECMAKE += "-Dfoxglove-sdk_DIR=${B}/_deps/foxglove_sdk-src/lib/cmake/foxglove-sdk"

SRC_URI += " \
    file://0001-redirect-sdk-url-to-local-file.patch \
    https://github.com/foxglove/foxglove-sdk/releases/download/sdk/v0.27.0/foxglove-v0.27.0-cpp-aarch64-unknown-linux-gnu.zip;name=aarch64;unpack=0;subdir=${BP} \
    https://github.com/foxglove/foxglove-sdk/releases/download/sdk/v0.27.0/foxglove-v0.27.0-cpp-x86_64-unknown-linux-gnu.zip;name=x86_64;unpack=0;subdir=${BP} \
"

SRC_URI[aarch64.sha256sum] = "d919d6e6358de1ac5ecca268ffeb9d4be3886d4820831b378053e2ed5d8345a2"
SRC_URI[x86_64.sha256sum] = "4790dad26adaced1a5f81530ed406bab7b60aa202a868eb78cfc04976b9ce6d7"

CXXFLAGS += "-Wno-error=old-style-cast"
