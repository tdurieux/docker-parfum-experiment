# ONNX Runtime Training Module for PyTorch
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

# CUDA development image for building sources
FROM nvidia/cuda:10.2-cudnn8-devel-ubuntu18.04 as builder

ARG TORCH_CUDA_VERSION=cu102
ARG TORCH_VERSION=1.9.0
ARG TORCHVISION_VERSION=0.10.0

# Install and update tools to minimize security vulnerabilities
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common wget apt-utils patchelf git libprotobuf-dev protobuf-compiler cmake && rm -rf /var/lib/apt/lists/*;
RUN unattended-upgrade
RUN apt-get autoremove -y

# Python and pip
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
RUN pip install --no-cache-dir --upgrade pip

# PyTorch
RUN pip install --no-cache-dir onnx==1.11.0 ninja
RUN pip install --no-cache-dir torch==${TORCH_VERSION}+${TORCH_CUDA_VERSION} torchvision==${TORCHVISION_VERSION}+${TORCH_CUDA_VERSION} -f https://download.pytorch.org/whl/torch_stable.html

# ORT Module
RUN pip install --no-cache-dir --pre onnxruntime-training -f https://download.onnxruntime.ai/onnxruntime_nightly_cu102.html

RUN pip install --no-cache-dir torch-ort
ENV TORCH_CUDA_ARCH_LIST="5.0 5.2 6.0 6.1 7.0 7.5+PTX"
RUN python -m torch_ort.configure

WORKDIR /workspace

# Basic testing
#   git clone https://github.com/pytorch/ort.git
#   pip install wget pandas transformers sklearn
#   python ./ort/tests/bert_for_sequence_classification.py
