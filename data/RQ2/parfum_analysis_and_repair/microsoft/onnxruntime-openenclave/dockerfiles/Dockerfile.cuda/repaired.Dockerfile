# --------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
# --------------------------------------------------------------
# Dockerfile to run ONNXRuntime with CUDA, CUDNN integration

# nVidia cuda 10.1 Base Image
FROM nvidia/cuda:10.1-cudnn7-devel
MAINTAINER Vinitra Swamy "viswamy@microsoft.com"

ARG ONNXRUNTIME_REPO=https://github.com/Microsoft/onnxruntime
ARG ONNXRUNTIME_BRANCH=master

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo git bash && rm -rf /var/lib/apt/lists/*;

WORKDIR /code
ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:/code/cmake-3.14.3-Linux-x86_64/bin:/opt/miniconda/bin:${PATH}
ENV LD_LIBRARY_PATH /opt/miniconda/lib:$LD_LIBRARY_PATH

# Prepare onnxruntime repository & build onnxruntime with CUDA
RUN git clone --single-branch --branch ${ONNXRUNTIME_BRANCH} --recursive ${ONNXRUNTIME_REPO} onnxruntime &&\
    /bin/sh onnxruntime/dockerfiles/scripts/install_common_deps.sh &&\
    cp onnxruntime/docs/Privacy.md /code/Privacy.md &&\
    cp onnxruntime/ThirdPartyNotices.txt /code/ThirdPartyNotices.txt &&\
    cp onnxruntime/dockerfiles/LICENSE-IMAGE.txt /code/LICENSE-IMAGE.txt &&\
    cd onnxruntime &&\
    /bin/sh ./build.sh --cuda_home /usr/local/cuda --cudnn_home /usr/lib/x86_64-linux-gnu/ --use_cuda --config Release --build_wheel --update --build --cmake_extra_defines ONNXRUNTIME_VERSION=$(cat ./VERSION_NUMBER) && \
    pip install --no-cache-dir /code/onnxruntime/build/Linux/Release/dist/*.whl && \
    cd .. && \
    rm -rf onnxruntime cmake-3.14.3-Linux-x86_64
