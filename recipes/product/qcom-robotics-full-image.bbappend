inherit psdk-image

# enable sample packages enabled by default
CORE_IMAGE_BASE_INSTALL:append = " \
    sample-hand-detection \
    sample-object-detction \
    sample-object-segmentation \
    sample-resnet101 \
    simulation-sample-amr-simple-motion \
    sample-remote-assistant \
"
