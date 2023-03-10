# ONNX Runtime Training Module for PyTorch
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.

# Usage
#   Build: docker build -f Dockerfile.ort-cu102-cudnn7-devel-ubuntu18.04 -t [image-name] .
#   Run: docker run -it --gpus all --name [run-name] [image-name]:latest /bin/bash
# Example:
#   docker build -f Dockerfile.ort-cu102-cudnn7-devel-ubuntu18.04 -t ort.cu102 .
#   docker run -it --gpus all --name my-experiments ort.cu102:latest /bin/bash

# CUDA development image for building sources
FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04 as builder

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
# pin onnx==1.9.0 to align with torch_ort dockerfile, otherwise AssertionError
RUN pip install --no-cache-dir onnx==1.9.0 ninja
RUN pip install --no-cache-dir torch==1.9.0+cu102 torchvision==0.10.0+cu102 torchaudio==0.9.0 -f https://download.pytorch.org/whl/torch_stable.html

# ORT Module
RUN pip install --no-cache-dir onnxruntime-training==1.9.0

RUN pip install --no-cache-dir torch-ort
RUN python -m torch_ort.configure

WORKDIR /stage

#Install huggingface transformers
RUN cd /stage && git clone https://github.com/microsoft/huggingface-transformers.git &&\
    cd huggingface-transformers &&\
    git checkout raviskolli/ort_t5 && \
    pip install --no-cache-dir -e .

# Install AzureML support and commonly used packages.
# pin datasets==1.9.0 due 'Sequence to truncate too short to respect the provided max_length' on roberta-large
# pin sacrebleu==1.5.1 due 'AttributeError: module sacrebleu has no attribute DEFAULT_TOKENIZER' on bart-large
RUN pip install --no-cache-dir azureml-defaults wget fairscale
RUN pip install --no-cache-dir sacrebleu==1.5.1 datasets==1.9.0 deepspeed
RUN pip install --no-cache-dir scipy sklearn accelerate
RUN pip install --no-cache-dir sentencepiece protobuf
