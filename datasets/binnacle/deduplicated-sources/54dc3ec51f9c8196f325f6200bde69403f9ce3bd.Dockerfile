#-------------------------------------------------------------------------
# Copyright(C) 2019 Intel Corporation.
# Licensed under the MIT License.
#--------------------------------------------------------------------------

FROM ubuntu:16.04

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
    python3 /onnxruntime/tools/ci_build/build.py --build_dir /onnxruntime/build --config Release --build_shared_lib --skip_submodule_sync --build_wheel --parallel --use_ngraph && \
    pip3 install /onnxruntime/build/Release/dist/onnxruntime_ngraph-*.whl && \
    rm -rf /onnxruntime