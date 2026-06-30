# Failure cause (root): the assimp 5.4.0 build fails because the MS3D importer source sets a local pointer variable that is never used, and the toolchain treats warnings as errors:
# code/AssetLib/MS3D/MS3DLoader.cpp:636:28: error: variable 'qu' set but not used [-Werror=unused-but-set-variable=]
EXTRA_OECMAKE += "-DCMAKE_CXX_FLAGS='-Wno-error=unused-but-set-variable'"
