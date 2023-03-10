ARG OS_VERSION=16.04
FROM ubuntu:${OS_VERSION}

ARG PYTHON_VERSION=3.5
ADD scripts /tmp/scripts
RUN /tmp/scripts/install_ubuntu.sh -p $PYTHON_VERSION && /tmp/scripts/install_deps_android.sh && /tmp/scripts/install_protobuf.sh && rm -rf /tmp/scripts

WORKDIR /root

ENV LD_LIBRARY_PATH /usr/local/openblas/lib:$LD_LIBRARY_PATH

ARG BUILD_UID=1000
ARG BUILD_USER=onnxruntimedev
RUN adduser --gecos 'onnxruntime Build User' --disabled-password $BUILD_USER --uid $BUILD_UID
WORKDIR /home/$BUILD_USER
USER $BUILD_USER