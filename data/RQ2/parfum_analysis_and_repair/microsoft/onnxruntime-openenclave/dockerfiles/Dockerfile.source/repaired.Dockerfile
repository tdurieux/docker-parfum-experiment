# --------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
# --------------------------------------------------------------
# Dockerfile to run ONNXRuntime with source build for CPU

# Ubuntu 16.04 Base Image
FROM ubuntu:16.04
MAINTAINER Vinitra Swamy "viswamy@microsoft.com"

ARG ONNXRUNTIME_REPO=https://github.com/Microsoft/onnxruntime
ARG ONNXRUNTIME_SERVER_BRANCH=master

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo git bash && rm -rf /var/lib/apt/lists/*;

WORKDIR /code
ENV PATH /opt/miniconda/bin:/code/cmake-3.14.3-Linux-x86_64/bin:${PATH}

# Prepare onnxruntime repository & build onnxruntime
RUN git clone --single-branch --branch ${ONNXRUNTIME_SERVER_BRANCH} --recursive ${ONNXRUNTIME_REPO} onnxruntime &&\
    /bin/sh onnxruntime/dockerfiles/scripts/install_common_deps.sh &&\
    cd onnxruntime &&\
    /bin/sh ./build.sh --use_openmp --config Release --build_wheel --update --build --parallel --cmake_extra_defines ONNXRUNTIME_VERSION=$(cat ./VERSION_NUMBER) && \
    pip install --no-cache-dir /code/onnxruntime/build/Linux/Release/dist/*.whl && \
    cd .. && \
    rm -rf onnxruntime cmake-3.14.3-Linux-x86_64
