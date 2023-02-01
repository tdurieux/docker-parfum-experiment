FROM ubuntu:bionic

LABEL Description="Ubuntu 18.04 environment with HDF5 1.10.8"

ENV DEBIAN_FRONTEND=noninteractive
ENV HDF5_LIBTOOL=/usr/bin/libtoolize

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        git \
        curl \
        wget \
        sudo \
        gpg \
        ca-certificates \
        m4 \
        autoconf \
        automake \
        libtool \
        pkg-config \
        cmake \
        libtool \
        zlib1g-dev \
        python3 \
        python3-pip \
        python3-dev \
        python3-setuptools \
        gcc \
        g++ \
        libopenmpi-dev \
        software-properties-common \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --batch --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null \
    && sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' \
    && apt-get update \
    && apt-get install --no-install-recommends cmake -y \
    && pip3 install --no-cache-dir psutil \
    && wget https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_10_8.tar.gz \
    && tar zxvf hdf5-1_10_8.tar.gz \
    && mv hdf5-hdf5-1_10_8 hdf5 \
    && cd hdf5 \
    && ./autogen.sh \
    && CC=mpicc ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/hdf5 --enable-parallel --enable-threadsafe --enable-unsupported \
    && make -j 8 \
    && make install \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && apt-get autoclean && rm hdf5-1_10_8.tar.gz
