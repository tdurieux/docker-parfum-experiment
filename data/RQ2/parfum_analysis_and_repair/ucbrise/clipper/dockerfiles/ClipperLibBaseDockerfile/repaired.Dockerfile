# This ARG isn't used but prevents warnings in the build script
ARG REGISTRY
ARG CODE_VERSION
FROM ubuntu:18.04

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

## Install basic packages.
RUN apt-get update -qq && apt-get install --no-install-recommends -y -qq \
    wget git && rm -rf /var/lib/apt/lists/*;

## Install dependent packages for Folly.
RUN apt-get install --no-install-recommends -y -qq \
    g++ cmake libboost-all-dev libevent-dev libdouble-conversion-dev \
    libgoogle-glog-dev libgflags-dev libiberty-dev liblz4-dev \
    liblzma-dev libsnappy-dev make zlib1g-dev binutils-dev \
    libjemalloc-dev libssl-dev pkg-config && rm -rf /var/lib/apt/lists/*;

## Install Folly.
RUN git clone https://github.com/facebook/folly \
    && cd folly \
    && git checkout -b tags/v2019.03.18.00 \
    && mkdir _build && cd _build \
    && CXXFLAGS="$CXXFLAGS -fPIC" CFLAGS="$CFLAGS -fPIC" cmake .. -DBUILD_SHARED_LIBS=ON \
    && make -j4 \
    && make install \
    && cd / \
    && rm -rf folly

## Install dependent packages for Clipper.
RUN apt-get install --no-install-recommends -y -qq \
    libhiredis-dev libzmq5 libzmq5-dev && rm -rf /var/lib/apt/lists/*;

## Install libev-dev for Clipper except event.h and event.c.
#  1. To use both Folly and libev, we have to exclude files(event.*) from compilation.
#     See https://github.com/facebook/folly/issues/601#issuecomment-347100410.
#  2. Be careful that this step has to be after installing Folly to avoid collision.
RUN wget https://dist.schmorp.de/libev/Attic/libev-4.25.tar.gz \
    && tar -zxvf libev-4.25.tar.gz \
    && cd libev-4.25 \
    && sed -i 's/event\.[ch]//g' Makefile.am \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make -j4 \
    && make install \
    && cd / \
    && rm -rf libev-4.25* && rm libev-4.25.tar.gz

## Install Cityhash.
RUN git clone https://github.com/google/cityhash \
    && cd cityhash \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make all check CXXFLAGS="-g -O3" \
    && make install \
    && cd / \
    && rm -rf cityhash

# vim: set filetype=dockerfile:
