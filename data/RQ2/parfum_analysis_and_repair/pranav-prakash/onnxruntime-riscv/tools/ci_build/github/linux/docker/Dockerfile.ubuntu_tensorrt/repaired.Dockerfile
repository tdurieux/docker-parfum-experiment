# Tag: nvcr.io/nvidia/tensorrt:20.12-py3
# Label: com.nvidia.cuda.version: 11.1.1
# Label: com.nvidia.cudnn.version: 8.0.5
# Ubuntu 20.04
FROM nvcr.io/nvidia/tensorrt:20.12-py3

ARG PYTHON_VERSION=3.8
ARG DEBIAN_FRONTEND=noninteractive

ADD scripts /tmp/scripts
RUN /tmp/scripts/install_ubuntu.sh -p $PYTHON_VERSION && /tmp/scripts/install_os_deps.sh && /tmp/scripts/install_python_deps.sh -p $PYTHON_VERSION && rm -rf /tmp/scripts \
    && rm /usr/local/bin/cmake && rm /usr/local/bin/ctest && rm -r /usr/local/share/cmake-3.14

WORKDIR /root

# Allow configure to pick up GDK and CuDNN where it expects it.
# (Note: $CUDNN_VERSION is defined by NVidia's base image)