# Tag: nvcr.io/nvidia/tensorrt:20.01-py3
# Label: com.nvidia.cuda.version: 10.2.89
# Label: com.nvidia.cudnn.version: 7.6.5
# Ubuntu 18.04
FROM nvcr.io/nvidia/tensorrt:20.01-py3

ARG PYTHON_VERSION=3.6

ADD scripts /tmp/scripts
RUN /tmp/scripts/install_ubuntu.sh -p $PYTHON_VERSION && /tmp/scripts/install_deps.sh -p $PYTHON_VERSION && rm -rf /tmp/scripts \
    && rm /usr/local/bin/cmake && rm /usr/local/bin/ctest && rm -r /usr/local/share/cmake-3.12

WORKDIR /root

# Allow configure to pick up GDK and CuDNN where it expects it.
# (Note: $CUDNN_VERSION is defined by NVidia's base image)