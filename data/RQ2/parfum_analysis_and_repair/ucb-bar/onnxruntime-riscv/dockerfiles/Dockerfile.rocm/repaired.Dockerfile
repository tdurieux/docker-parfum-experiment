# --------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
# --------------------------------------------------------------
# Dockerfile to run ONNXRuntime with MIGraphX integration
#--------------------------------------------------------------------------

FROM ubuntu:18.04

ARG ONNXRUNTIME_REPO=https://github.com/Microsoft/onnxruntime
ARG ONNXRUNTIME_BRANCH=master

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Install rocm
RUN apt-get update && apt-get install -y gnupg2 --no-install-recommends curl && \
  curl -f -sL https://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | apt-key add - && \
  sh -c 'echo deb [arch=amd64] http://repo.radeon.com/rocm/apt/4.0/ xenial main > /etc/apt/sources.list.d/rocm.list' && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get install -y --no-install-recommends sudo git bash build-essential cmake libelf1 rocm-dkms libpython3.6-dev python3-pip miopen-hip rocblas\
    libnuma-dev kmod half hipsparse rocfft hipblas && rm -rf /var/lib/apt/lists/*;

# Install yapf
RUN pip3 install --no-cache-dir yapf==0.28.0

ENV PATH /opt/miniconda/bin:/code/cmake-3.14.3-Linux-x86_64/bin:${PATH}

# Install dependencies
COPY ./scripts/install_rocm_deps.sh /
RUN chmod +x /install_rocm_deps.sh && /install_rocm_deps.sh && rm /install_rocm_deps.sh

WORKDIR /code

# Prepare onnxruntime repository & build onnxruntime
RUN git clone --single-branch --branch ${ONNXRUNTIME_BRANCH} --recursive ${ONNXRUNTIME_REPO} onnxruntime &&\
    /bin/sh onnxruntime/dockerfiles/scripts/install_common_deps.sh &&\
    cd onnxruntime &&\
    /bin/sh ./build.sh --config Release --build_wheel --update --build --parallel --cmake_extra_defines\
    ONNXRUNTIME_VERSION=$(cat ./VERSION_NUMBER) --use_rocm --rocm_home=/opt/rocm && \
    pip install --no-cache-dir /code/onnxruntime/build/Linux/Release/dist/*.whl && \
    cd .. && \
    rm -rf onnxruntime cmake-3.14.3-Linux-x86_64

