# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG UBUNTU_VERSION=18.04
ARG CUDA=10.1

FROM nvidia/cuda${ARCH:+-$ARCH}:${CUDA}-base-ubuntu${UBUNTU_VERSION} as base

# ARCH and CUDA are specified again because the FROM directive resets ARGs
# (but their default value is retained if set previously)
ARG ARCH
ARG CUDA
ARG CUDNN=7.6.4.38-1
ARG CUDNN_MAJOR_VERSION=7
ARG LIB_DIR_PREFIX=x86_64
ARG LIBNVINFER=6.0.1-1
ARG LIBNVINFER_MAJOR_VERSION=6

# Needed for string substitution
SHELL ["/bin/bash", "-c"]

# These dependencies come from the list at the official Tensorflow GPU base
# image:
# https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/dockerfiles/dockerfiles/gpu.Dockerfile

RUN apt-get update && apt-get install -y --no-install-recommends \
  build-essential \
  cuda-command-line-tools-${CUDA/./-} \
  # There appears to be a regression in libcublas10=10.2.2.89-1 which
  # prevents cublas from initializing in TF. See
  # https://github.com/tensorflow/tensorflow/issues/9489#issuecomment-562394257
  libcublas10=10.2.1.243-1 \
  cuda-nvrtc-${CUDA/./-} \
  cuda-cufft-${CUDA/./-} \
  cuda-curand-${CUDA/./-} \
  cuda-cusolver-${CUDA/./-} \
  cuda-cusparse-${CUDA/./-} \
  curl \
  libcudnn7=${CUDNN}+cuda${CUDA} \
  libfreetype6-dev \
  libhdf5-serial-dev \
  libzmq3-dev \
  pkg-config \
  software-properties-common \
  unzip \
  libnvinfer${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda${CUDA} \
  libnvinfer-plugin${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda${CUDA} \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# For CUDA profiling, TensorFlow requires CUPTI.
ENV LD_LIBRARY_PATH /usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:$LD_LIBRARY_PATH

# Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
# dynamic linker run-time bindings