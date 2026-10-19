SRC_URI:remove = "gitsm://github.com/microsoft/onnxruntime.git;protocol=https;branch=rel-1.26.0;name=ort"

SRC_URI:prepend = "gitsm://github.com/microsoft/onnxruntime.git;protocol=https;nobranch=1;name=ort "

SRCREV_ort = "8c546c37b43caaca1fa25db430dab94b901cf277"
