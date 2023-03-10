# ==============================================================================
# Copyright (C) Intel Corporation
#
# SPDX-License-Identifier: MIT
# ==============================================================================

ARG VPL_INSTALL_PREFIX=/opt/intel/onevpl
ARG DOCKER_REGISTRY

# Stage 1
FROM ${DOCKER_REGISTRY}centos:centos7 AS vpl_base
ENV TZ=Europe/Moscow
RUN yum update -y && yum install -y centos-release-scl && \
   yum-config-manager --enable rhel-server-rhscl-7-rpms && \
   yum install -y git libtool make pkgconfig devtoolset-7 && rm -rf /var/cache/yum

RUN cd /tmp && \
    curl -f -O -L https://cmake.org/files/v3.12/cmake-3.12.3.tar.gz && \
    tar zxvf cmake-3.* && \
    cd cmake-3.* && \
    source /opt/rh/devtoolset-7/enable && \
    ./bootstrap --prefix=/usr/local && \
    make -j$(nproc) && \
    make install

# Stage 2
FROM vpl_base AS vpl_build
ARG VPL_INSTALL_PREFIX
COPY . /oneVPL
RUN cd /oneVPL && \
    rm -rf _build && \
    mkdir _build && \
    cd _build && \
    source /opt/rh/devtoolset-7/enable && \
    cmake -DCMAKE_INSTALL_PREFIX=${VPL_INSTALL_PREFIX} .. && \
    make -j $(nproc --all) && \
    make install


# Runtime image build
FROM ${DOCKER_REGISTRY}centos:centos7
LABEL Description="This is the CentOS 7 base image for the oneAPI Video Processing Library API"
LABEL Vendor="Intel Corporation"
ARG VPL_INSTALL_PREFIX
ENV LD_LIBRARY_PATH=${VPL_INSTALL_PREFIX}/lib
ENV PKG_CONFIG_PATH=${VPL_INSTALL_PREFIX}/pkgconfig
ENV PATH="${PATH}:/${VPL_INSTALL_PREFIX}/bin"
COPY --from=vpl_build ${VPL_INSTALL_PREFIX} ${VPL_INSTALL_PREFIX}
