# Copyright (c) 2021-2022, NVIDIA CORPORATION. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#           http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ARG FROM_IMAGE_NAME=nvcr.io/nvidia/pytorch:21.12-py3
FROM ${FROM_IMAGE_NAME}

# Ensure apt-get won't prompt for selecting options
ENV DEBIAN_FRONTEND=noninteractive
ENV DCGM_VERSION=2.2.9

# Install perf_client required library
RUN apt-get update && \
    apt-get install --no-install-recommends -y libb64-dev libb64-0d curl && \
    curl -f -s -L -O https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/datacenter-gpu-manager_${DCGM_VERSION}_amd64.deb && \
    dpkg -i datacenter-gpu-manager_${DCGM_VERSION}_amd64.deb && \
    rm datacenter-gpu-manager_${DCGM_VERSION}_amd64.deb && rm -rf /var/lib/apt/lists/*;

# Set workdir and python path
WORKDIR /workspace
ENV PYTHONPATH /workspace

# In some cases in needed to uninstall typing
RUN apt update && apt install --no-install-recommends -y p7zip-full && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install requirements

ADD requirements.txt /workspace/requirements.txt
ADD triton/requirements.txt /workspace/triton/requirements.txt
RUN pip install --no-cache-dir -r /workspace/requirements.txt
RUN pip install --no-cache-dir -r /workspace/triton/requirements.txt

# Add model files to workspace
ADD . /workspace


