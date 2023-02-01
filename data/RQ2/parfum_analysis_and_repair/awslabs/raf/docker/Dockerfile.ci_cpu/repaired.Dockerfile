# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu18.04

# Base scripts
RUN apt-get update --fix-missing && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y awscli && rm -rf /var/lib/apt/lists/*; COPY install/ubuntu_install_core.sh /install/ubuntu_install_core.sh
RUN bash /install/ubuntu_install_core.sh

COPY install/ubuntu_install_python.sh /install/ubuntu_install_python.sh
RUN bash /install/ubuntu_install_python.sh cpu

COPY install/ubuntu_install_llvm.sh /install/ubuntu_install_llvm.sh
RUN bash /install/ubuntu_install_llvm.sh

# AWS Batch setup
COPY batch/entry.sh /batch/entry.sh

RUN pip3 install --no-cache-dir --upgrade awscli

# To prevent `black` command line errors caused by ASCII encoding
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
