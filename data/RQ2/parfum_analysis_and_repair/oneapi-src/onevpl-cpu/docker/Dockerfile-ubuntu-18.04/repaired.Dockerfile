# ==============================================================================
# Copyright (C) 2020 Intel Corporation
#
# SPDX-License-Identifier: MIT
# ==============================================================================

ARG VPL_INSTALL_PREFIX=/opt/intel/onevpl

# Stage 1
FROM ubuntu:18.04 AS vpl_base
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Moscow
RUN apt-get update && apt-get install -y --no-install-recommends \
      build-essential \
      git \
      pkg-config \
      yasm \
      nasm \
      cmake \
      python3 \
      python3-setuptools \
      python3-pip && \
    pip3 install --no-cache-dir -U wheel --user && \
    pip3 install --no-cache-dir meson ninja && \
    rm -rf /var/lib/apt/lsits/* && rm -rf /var/lib/apt/lists/*;


# Stage 2
FROM vpl_base AS vpl_bootstrap
COPY script /oneVPL/script

RUN bash -c "source /oneVPL/script/bootstrap"

# Stage 3
FROM vpl_base AS vpl_build
COPY --from=vpl:ubuntu18.04 /opt/intel/onevpl /opt/intel/onevpl
COPY --from=vpl_bootstrap /oneVPL/_deps /oneVPL/_deps
ENV VPL_INSTALL_DIR=/opt/intel/onevpl
ENV VPL_BIN=/opt/intel/onevpl/bin
ENV VPL_LIB=/opt/intel/onevpl/lib
ENV VPL_INCLUDE=/opt/intel/onevpl/include
COPY . /oneVPL
COPY --from=vpl_bootstrap /oneVPL/_deps /oneVPL/_deps

ARG VPL_BUILD_DEPENDENCIES=/oneVPL/_deps
ARG VPL_INSTALL_PREFIX
RUN cd /oneVPL && \
    rm -rf _build && \
    mkdir _build && \
    cd _build && \
    cmake -DCMAKE_INSTALL_PREFIX=${VPL_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=Release .. && \
    make -j $(nproc --all) && \
    make install


# Runtime image build
FROM ubuntu:18.04
LABEL Description="This is the Ubuntu 18.04 CPU reference implementation image for the oneAPI Video Processing Library API"
LABEL Vendor="Intel Corporation"
ARG VPL_INSTALL_PREFIX
ENV LD_LIBRARY_PATH=${VPL_INSTALL_PREFIX}/lib:${VPL_INSTALL_PREFIX}/lib64
ENV PKG_CONFIG_PATH=${VPL_INSTALL_PREFIX}/pkgconfig
ENV PATH="${PATH}:/${VPL_INSTALL_PREFIX}/bin"
COPY --from=vpl_build ${VPL_INSTALL_PREFIX} ${VPL_INSTALL_PREFIX}
