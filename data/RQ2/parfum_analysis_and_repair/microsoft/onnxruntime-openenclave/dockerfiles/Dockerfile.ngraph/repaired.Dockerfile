#-------------------------------------------------------------------------
# Copyright(C) 2019 Intel Corporation.
# Licensed under the MIT License.
#--------------------------------------------------------------------------

FROM ubuntu:16.04

ARG ONNXRUNTIME_REPO=https://github.com/Microsoft/onnxruntime
ARG ONNXRUNTIME_BRANCH=master

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install --no-install-recommends -y sudo git bash && rm -rf /var/lib/apt/lists/*;

ENV PATH /opt/miniconda/bin:/code/cmake-3.14.3-Linux-x86_64/bin:$PATH
ENV LD_LIBRARY_PATH=/opt/miniconda/lib:$LD_LIBRARY_PATH
ENV LANG en_US.UTF-8

WORKDIR /code
RUN git clone --single-branch --branch ${ONNXRUNTIME_BRANCH} --recursive ${ONNXRUNTIME_REPO} onnxruntime && \
    cp onnxruntime/docs/Privacy.md /code/Privacy.md && \
    cp onnxruntime/dockerfiles/LICENSE-IMAGE.txt /code/LICENSE-IMAGE.txt && \
    cp onnxruntime/ThirdPartyNotices.txt /code/ThirdPartyNotices.txt && \
    /bin/sh onnxruntime/dockerfiles/scripts/install_common_deps.sh && \
    onnxruntime/tools/ci_build/github/linux/docker/scripts/install_ubuntu.sh -p 3.5 && \
    onnxruntime/build.sh --use_openmp --config RelWithDebInfo --update --build --use_ngraph --build_wheel && \
    pip install --no-cache-dir onnxruntime/build/Linux/RelWithDebInfo/dist/*-linux_x86_64.whl && rm -rf /code/onnxruntime /code/cmake-3.14.3-Linux-x86_64
