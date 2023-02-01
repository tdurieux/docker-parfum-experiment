#-------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
#--------------------------------------------------------------------------
# Official docker container for ONNX Runtime Server
# Ubuntu 16.04, CPU version, Python 3.
#--------------------------------------------------------------------------

FROM ubuntu:16.04 AS minimal
MAINTAINER Harry Yang "huayang@microsoft.com"

FROM ubuntu:16.04 AS build
ARG PYTHON_VERSION=3.5
ARG ONNXRUNTIME_REPO=https://github.com/Microsoft/onnxruntime
ARG ONNXRUNTIME_SERVER_BRANCH=master
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y sudo git bash

ENV PATH="/opt/cmake/bin:${PATH}"
RUN git clone --single-branch --branch ${ONNXRUNTIME_SERVER_BRANCH} --recursive ${ONNXRUNTIME_REPO} onnxruntime
RUN /onnxruntime/tools/ci_build/github/linux/docker/scripts/install_ubuntu.sh -p ${PYTHON_VERSION} && \
    /onnxruntime/tools/ci_build/github/linux/docker/scripts/install_deps.sh

WORKDIR /
RUN mkdir -p /onnxruntime/build && \
    python3 /onnxruntime/tools/ci_build/build.py --build_dir /onnxruntime/build --config Release --build_server --cmake_extra_defines ONNXRUNTIME_VERSION=$(cat ./VERSION_NUMBER)

FROM minimal AS final
WORKDIR /onnxruntime/server/
ENV MODEL_ABSOLUTE_PATH /onnxruntime/model/model.onnx
COPY --from=build /onnxruntime/build/Release/onnxruntime_server /onnxruntime/server/
RUN apt-get update \
    && apt-get install -y libgomp1
ENTRYPOINT /onnxruntime/server/onnxruntime_server --model_path $MODEL_ABSOLUTE_PATH
