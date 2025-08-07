inherit psdk-image

# enable sample packages enabled by default
FUNCTION:append:qcom-custom-bsp = " \
    sample-hand-detection \
    sample-object-detction \
    sample-object-segmentation \
    sample-resnet101 \
    simulation-sample-amr-simple-motion \
    sample-remote-assistant \
"
