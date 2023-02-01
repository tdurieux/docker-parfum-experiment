# ==============================================================================
# Copyright (C) 2020 Intel Corporation
#
# SPDX-License-Identifier: MIT
# ==============================================================================

ARG VPL_INSTALL_PREFIX=/opt/intel/onevpl

# Stage 1
FROM centos:centos7 AS vpl_base
ENV TZ=Europe/Moscow
RUN yum install -y centos-release-scl \
    && yum-config-manager --enable rhel-server-rhscl-7-rpms \
    && yum install -y libtool make pkgconfig bzip2 openssl-devel \
    && yum install -y devtoolset-7 \
    && yum install -y python3 python3-pip \
    && pip3 install --no-cache-dir meson ninja && rm -rf /var/cache/yum

# install git>=1.8.5, needed by SVT-AV1 ffmpeg-plugin patch
RUN yum install -y \
    https://repo.ius.io/ius-release-el7.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum install -y \
    git224 && rm -rf /var/cache/yum

# cmake
RUN cd /tmp && \
    curl -f -O -L https://github.com/Kitware/CMake/releases/download/v3.18.4/cmake-3.18.4.tar.gz && \
    tar zxvf cmake-3.* && \
    cd cmake-3.* && \
    source /opt/rh/devtoolset-7/enable && \
    ./bootstrap --prefix=/usr/local --parallel=$(nproc) && \
    make -j$(nproc) && \
    make install

# build nasm
RUN cd /tmp && \
    curl -f -O -L https://www.nasm.us/pub/nasm/releasebuilds/2.14.02/nasm-2.14.02.tar.bz2 && \
    tar xjvf nasm-2.14.02.tar.bz2 && \
    cd nasm-2.14.02 && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="/usr" --bindir="/usr/bin" && \
    make && \
    make install && rm nasm-2.14.02.tar.bz2

# build yasm
RUN cd /tmp && \
    curl -f -O -L --retry 5 https://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz && \
    tar xzvf yasm-1.3.0.tar.gz && \
    source /opt/rh/devtoolset-7/enable && \
    cd yasm-1.3.0 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix="/usr" --bindir="/usr/bin" && \
    make && \
    make install && rm yasm-1.3.0.tar.gz

# Stage 2
FROM vpl_base AS vpl_bootstrap
COPY script /oneVPL/script
RUN source /opt/rh/devtoolset-7/enable && \
   source /oneVPL/script/bootstrap


# Stage 3
FROM vpl_base AS vpl_build
COPY --from=vpl:centos7 /opt/intel/onevpl /opt/intel/onevpl
COPY --from=vpl_bootstrap /oneVPL/_deps /oneVPL/_deps
ENV VPL_INSTALL_DIR=/opt/intel/onevpl
ENV VPL_BIN=/opt/intel/onevpl/bin
ENV VPL_LIB=/opt/intel/onevpl/lib
ENV VPL_INCLUDE=/opt/intel/onevpl/include
COPY . /oneVPL
# RUN cp -r /oneVPL/_deps/lib64/* /oneVPL/_deps/lib
ARG VPL_BUILD_DEPENDENCIES=/oneVPL/_deps
ARG VPL_INSTALL_PREFIX
RUN cd /oneVPL && \
    rm -rf _build && \
    mkdir _build && \
    cd _build && \
    source /opt/rh/devtoolset-7/enable && \
    cmake -DCMAKE_INSTALL_PREFIX=${VPL_INSTALL_PREFIX} -DCMAKE_BUILD_TYPE=Release .. && \
    make -j $(nproc --all) && \
    make install


# Runtime image build
FROM centos:centos7
LABEL Description="This is the CentOS 7 CPU reference implementation image for the oneAPI Video Processing Library API"
LABEL Vendor="Intel Corporation"
ARG VPL_INSTALL_PREFIX
ENV LD_LIBRARY_PATH=${VPL_INSTALL_PREFIX}/lib:${VPL_INSTALL_PREFIX}/lib64
ENV PKG_CONFIG_PATH=${VPL_INSTALL_PREFIX}/pkgconfig
ENV PATH="${PATH}:/${VPL_INSTALL_PREFIX}/bin"
COPY --from=vpl_build ${VPL_INSTALL_PREFIX} ${VPL_INSTALL_PREFIX}
COPY --from=vpl_bootstrap /oneVPL/_deps /oneVPL/_deps


