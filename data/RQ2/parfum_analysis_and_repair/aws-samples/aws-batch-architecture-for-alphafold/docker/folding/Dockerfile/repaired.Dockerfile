# Original Copyright 2021 DeepMind Technologies Limited
# Modifications Copyright 2022 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0

### ---------------------------------------------
### Modified by Amazon Web Services (AWS) to update cuda version and add Alphafold
### parameter
ARG CUDA=11.1.1
ARG AF_VERSION=v2.2.2
ARG UBUNTU_VERSION=20.04
ARG AWS_DEFAULT_REGION
ARG AWS_CONTAINER_CREDENTIALS_RELATIVE_URI
FROM nvcr.io/nvidia/cuda:${CUDA}-cudnn8-runtime-ubuntu${UBUNTU_VERSION}

# FROM directive resets ARGS, so we specify again (the value is retained if
# previously set).
ARG CUDA
ARG AF_VERSION
ARG AWS_DEFAULT_REGION
ARG AWS_CONTAINER_CREDENTIALS_RELATIVE_URI
### ---------------------------------------------

# Use bash to support string substitution.
SHELL ["/bin/bash", "-c"]

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      build-essential \
      cmake \
      cuda-command-line-tools-$(cut -f1,2 -d- <<< ${CUDA//./-}) \
      git \
      hmmer \
      kalign \
      tzdata \
      wget \
      # Address https://ubuntu.com/security/CVE-2022-24407
      libsasl2-modules-sql=2.1.27+dfsg-2ubuntu0.1 \ 
      # Address https://ubuntu.com/security/CVE-2022-24407, https://ubuntu.com/security/CVE-2021-3711,
      # and https://ubuntu.com/security/CVE-2022-0778
      openssl \
      # Address https://ubuntu.com/security/CVE-2021-33910
      systemd=245.4-4ubuntu3.17 \
      # Address additional MEDIUM vulnerabilities