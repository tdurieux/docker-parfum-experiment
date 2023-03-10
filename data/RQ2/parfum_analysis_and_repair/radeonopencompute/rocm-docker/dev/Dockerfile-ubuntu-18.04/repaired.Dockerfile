# This dockerfile is meant to serve as a rocm base image.  It registers the debian rocm package repository, and
# installs the rocm-dev package.

FROM ubuntu:18.04
LABEL maintainer=peng.sun@amd.com

# Register the ROCM package repository, and install rocm-dev package
ARG ROCM_VERSION=4.5.2
ARG AMDGPU_VERSION=21.40.2

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates curl libnuma-dev gnupg \
  && curl -f -sL https://repo.radeon.com/rocm/rocm.gpg.key | apt-key add - \
  && printf "deb [arch=amd64] https://repo.radeon.com/rocm/apt/$ROCM_VERSION/ ubuntu main" | tee /etc/apt/sources.list.d/rocm.list \
  && printf "deb [arch=amd64] https://repo.radeon.com/amdgpu/$AMDGPU_VERSION/ubuntu bionic main" | tee /etc/apt/sources.list.d/amdgpu.list \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  sudo \
  libelf1 \
  kmod \
  file \
  python3 \
  python3-pip \
  rocm-dev \
  build-essential && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
