# ==============================================================================
# Copyright (C) Intel Corporation
#
# SPDX-License-Identifier: MIT
# ==============================================================================

ARG VPL_BUILD_DEPENDENCIES=/oneVPL/_deps
ARG VPL_INSTALL_PREFIX=/opt/intel/onevpl
ARG DOCKER_REGISTRY

# Stage 1
FROM ${DOCKER_REGISTRY}ubi AS vpl_base
ENV TZ=Europe/Moscow
RUN yum install -y cmake gcc gcc-c++ git libtool make pkgconfig libarchive && rm -rf /var/cache/yum


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
FROM registry.access.redhat.com/ubi8/ubi
LABEL Description="This is the RHEL 8.x base image for the oneAPI Video Processing Library API"
LABEL Vendor="Intel Corporation"
ARG VPL_INSTALL_PREFIX
ENV LD_LIBRARY_PATH=${VPL_INSTALL_PREFIX}/lib
ENV PKG_CONFIG_PATH=${VPL_INSTALL_PREFIX}/pkgconfig
ENV PATH="${PATH}:/${VPL_INSTALL_PREFIX}/bin"
COPY --from=vpl_build ${VPL_INSTALL_PREFIX} ${VPL_INSTALL_PREFIX}
