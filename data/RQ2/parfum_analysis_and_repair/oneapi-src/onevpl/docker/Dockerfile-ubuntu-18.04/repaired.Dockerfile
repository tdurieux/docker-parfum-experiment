# ==============================================================================
# Copyright (C) Intel Corporation
#
# SPDX-License-Identifier: MIT
# ==============================================================================

ARG VPL_INSTALL_PREFIX=/opt/intel/onevpl
ARG DOCKER_REGISTRY

# Stage 1
FROM ${DOCKER_REGISTRY}ubuntu:18.04 AS vpl_base
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      git \
      pkg-config \
      ca-certificates \
      dh-autoreconf \
      libdrm-dev  \
      cmake && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/intel/libva.git && \
    cd libva && \
    git fetch --tags && \
    git checkout $(git describe --tags `git rev-list --tags --max-count=1`) && \
    ./autogen.sh && \
    make -j $(nproc --all) && \
    make install

# Stage 2
FROM vpl_base AS vpl_build
ARG VPL_INSTALL_PREFIX
COPY . /oneVPL
RUN cd /oneVPL && \
    rm -rf _build && \
    mkdir _build && \
    cd _build && \
    cmake -DCMAKE_INSTALL_PREFIX=${VPL_INSTALL_PREFIX} .. && \
    make -j $(nproc --all) && \
    make install


# Runtime image build