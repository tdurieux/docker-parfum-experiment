FROM ubuntu:18.04

ENV TZ=Europe/Minsk
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN groupadd --gid 1000 onnc \
    && useradd --uid 1000 --gid onnc --shell /bin/bash --create-home onnc --home-dir /onnc/ \
    && mkdir -p /etc/sudoers.d \
    && echo 'onnc ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers.d/onnc \
    && chmod 440 /etc/sudoers.d/onnc

RUN sed -i 's/archive.ubuntu.com/ftp.ubuntu-tw.net/' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        sudo \
        gcc g++ git cmake automake libtool protobuf-compiler libprotoc-dev pkg-config python2.7 python2.7-dev python-pip libgoogle-glog-dev flex bison curl \
        libllvm5.0 llvm-5.0 llvm-5.0-dev llvm-5.0-doc llvm-5.0-examples llvm-5.0-runtime llvm-5.0-tools \
        rsync time rename expect \
    && rm -rf /var/lib/apt/lists/*

USER onnc

RUN sudo -H pip install --no-cache-dir setuptools

COPY --chown=onnc:onnc ./external/onnx /onnc/onnx
RUN sudo -H pip install --no-cache-dir /onnc/onnx

WORKDIR /onnc/onnc-umbrella
RUN sudo chown onnc:onnc /onnc/onnc-umbrella

COPY --chown=onnc:onnc ./external ./external/
COPY --chown=onnc:onnc ./scripts ./scripts/
COPY --chown=onnc:onnc ./build.* ./

RUN mkdir -p ./src

ARG THREAD=4

RUN MAX_MAKE_JOBS=${THREAD} \
    EXTERNAL_ONLY=true \
    ./build.cmake.sh normal
