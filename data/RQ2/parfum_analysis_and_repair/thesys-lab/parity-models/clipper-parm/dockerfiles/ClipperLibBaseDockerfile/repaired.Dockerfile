# This ARG isn't used but prevents warnings in the build script
ARG CODE_VERSION
FROM debian:stretch-slim

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

RUN apt-get update && apt-get install --no-install-recommends -y g++ automake autoconf autoconf-archive libtool libboost-all-dev \
    libevent-dev libdouble-conversion-dev libgoogle-glog-dev libgflags-dev liblz4-dev \
    liblzma-dev libsnappy-dev make zlib1g-dev binutils-dev libjemalloc-dev libssl-dev \
    pkg-config libiberty-dev git cmake libev-dev libhiredis-dev libzmq5 libzmq5-dev build-essential && rm -rf /var/lib/apt/lists/*;

## Install Folly
RUN git clone https://github.com/facebook/folly \
    && cd folly/folly \
    && git checkout tags/v2017.08.14.00 \
    && autoreconf -ivf \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make -j4 \
    && make install

## Install Cityhash
RUN git clone https://github.com/google/cityhash \
    && cd cityhash \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make all check CXXFLAGS="-g -O3" \
    && make install

# vim: set filetype=dockerfile:
