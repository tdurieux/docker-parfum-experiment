# Copyright Amazon.com Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# *NOTE* we have to limit our number of layers heres because in presubmits there
# is no overlay fs and we will run out of space quickly
ARG BASE_IMAGE
ARG BUILDER_IMAGE
ARG BUILT_BUILDER_IMAGE
FROM ${BUILDER_IMAGE} as builder

ARG TARGETARCH

ENV CMAKE_VERSION=3.20.2
ENV LIBSSH2_VERSION=1.10.0
ENV LIBGIT2_VERSION=1.3.1
ENV BUILD_DEPS="gcc gzip make openssl-devel openssl-libs tar wget"

COPY "${TARGETARCH}-git-checksums" /tmp/checksums

# Copy scripts in every variant since we do not rebuild the base
# every time these scripts change. This ensures whenever a variant is
# built it has the latest scripts in the builder
COPY scripts/ /usr/bin

RUN set -x && \
    export TARGETARCH="${TARGETARCH/amd64/x86_64}" && \
    export TARGETARCH="${TARGETARCH/arm64/aarch64}" && \
    # manually "install" systemd to avoid installing the entire dep tree
    # git deps on less, which we wont be using in the image
    # do not need openssh, just the clients for git to fork (ssh)
    # rpm comes from openlbdap/nss but we only need the libs
    clean_install "less openssh rpm systemd" true true && \
    clean_install "git-core libssh2 openssh-clients openssl-libs gnupg" && \
    install_if_al2022 "libgit2" && \
    remove_package "less openssh rpm systemd" true && \
    # we are keeping bash on this image since downstream images use to exec git
    remove_package "coreutils findutils gawk grep info sed" && \
    if grep -q "2022" "/etc/os-release" ; then cleanup "git" && exit; fi && \
    # building libgit2 + libssh2
    mkdir -p /tmp/sources && \
    cd /tmp/sources && \
    yum install -y $BUILD_DEPS && \
    wget \
        --progress dot:giga \
        https://github.com/libssh2/libssh2/releases/download/libssh2-${LIBSSH2_VERSION}/libssh2-${LIBSSH2_VERSION}.tar.gz && \
    wget \
        --progress dot:giga \
        https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-${TARGETARCH}.tar.gz && \
    wget \
        --progress dot:giga \ 
        https://github.com/libgit2/libgit2/archive/refs/tags/v${LIBGIT2_VERSION}.tar.gz -O libgit2-${LIBGIT2_VERSION}.tar.gz && \
    sha256sum -c /tmp/checksums && \
    # al2 provided libssh is out of date and does not work with ssh/github
    tar -xzf libssh2-${LIBSSH2_VERSION}.tar.gz && \
    cd  /tmp/sources/libssh2-${LIBSSH2_VERSION} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-static --enable-shared --prefix=/usr --libdir=/usr/lib64 && \
    make && \
    make install && \
    mkdir -p $NEWROOT/usr/share/doc/libssh2-${LIBSSH2_VERSION}/ && \
    cp ./COPYING $NEWROOT/usr/share/doc/libssh2-${LIBSSH2_VERSION}/ && \
    cp -d /usr/lib64/libssh2* $NEWROOT/usr/lib64 && \
    # CMAKE for libgit build
    cd /tmp/sources && \
    tar -xzf cmake-${CMAKE_VERSION}-linux-${TARGETARCH}.tar.gz && \
    mv cmake-${CMAKE_VERSION}-linux-${TARGETARCH}/bin/* /usr/bin && \
    mkdir /usr/share/cmake-3.20 && \
    mv cmake-${CMAKE_VERSION}-linux-${TARGETARCH}/share/cmake-3.20/* /usr/share/cmake-3.20 && \
    # Install Libgit2
    cd /tmp/sources && \
    tar -xzf libgit2-${LIBGIT2_VERSION}.tar.gz && \
    cd /tmp/sources/libgit2-${LIBGIT2_VERSION} && \
    mkdir build && \
    cd build && \
    cmake -DBUILD_CLAR=off -DCMAKE_BUILD_TYPE=Release .. && \
    cmake --build  . && \
    cmake --install . && \
    mkdir -p $NEWROOT/usr/share/doc/libgit2-${LIBGIT2_VERSION}/ && \
    cp ../COPYING $NEWROOT/usr/share/doc/libgit2-${LIBGIT2_VERSION} && \
    cp -d /usr/local/lib64/libgit2* $NEWROOT/usr/lib64 && \
    # Since downstream of this image we need to build libgit2 we need the headers and pc files
    mkdir -p $NEWROOT/usr/lib64/pkgconfig && \
    mkdir -p $NEWROOT/usr/include && \
    cp /usr/local/lib64/pkgconfig/libgit2* $NEWROOT/usr/lib64/pkgconfig && \
    cp /usr/lib64/pkgconfig/* $NEWROOT/usr/lib64/pkgconfig && \
    cp -rf /usr/local/include/git2* $NEWROOT/usr/include && \
    cd / && \
    rm -rf /tmp/sources && \
    yum erase -y "$BUILD_DEPS" && \
    cleanup "git" && rm -rf /var/cache/yum
