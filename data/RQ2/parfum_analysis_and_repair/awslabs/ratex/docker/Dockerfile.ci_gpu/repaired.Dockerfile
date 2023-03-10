# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu18.04
ARG PYTORCH_VERSION=nightly

# Install basic dependencies.
RUN apt-get update --fix-missing
COPY install/ubuntu_install_core.sh /install/ubuntu_install_core.sh
RUN bash /install/ubuntu_install_core.sh

# Install docker
RUN apt-get install --no-install-recommends -y docker.io && rm -rf /var/lib/apt/lists/*;

# Install Python packages.
COPY install/ubuntu_install_python.sh /install/ubuntu_install_python.sh
RUN bash /install/ubuntu_install_python.sh

# Install LLVM.
COPY install/ubuntu_install_llvm.sh /install/ubuntu_install_llvm.sh
RUN bash /install/ubuntu_install_llvm.sh

# AWS Batch setup
COPY batch/entry.sh /batch/entry.sh
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y awscli && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade awscli

# Environment variables
ENV PATH=/usr/local/cuda/bin:${PATH}
ENV C_INCLUDE_PATH=/usr/local/cuda/include:${C_INCLUDE_PATH}
ENV CPLUS_INCLUDE_PATH=/usr/local/cuda/include:${CPLUS_INCLUDE_PATH}
ENV LIBRARY_PATH=/usr/local/cuda/lib64:${LIBRARY_PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

# Install PyTorch with CUDA
COPY install/ubuntu_install_torch.sh /install/ubuntu_install_torch.sh
RUN bash /install/ubuntu_install_torch.sh cu113 $PYTORCH_VERSION
ENV PYTORCH_SOURCE_PATH=/pytorch

# Install apex
COPY install/ubuntu_install_apex.sh /install/ubuntu_install_apex.sh
RUN bash /install/ubuntu_install_apex.sh

# To prevent `black` command line errors caused by ASCII encoding
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
