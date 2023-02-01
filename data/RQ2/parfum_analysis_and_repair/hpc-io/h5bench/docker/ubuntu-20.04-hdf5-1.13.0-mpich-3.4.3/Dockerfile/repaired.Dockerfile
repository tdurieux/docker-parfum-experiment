FROM ubuntu:focal

LABEL Description="Ubuntu 20.04 environment with HDF5 1.13.0 and MPICH 3.4.3"

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
        software-properties-common \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --batch --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null \
    && sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' \
    && apt-get update \
    && apt-get install --no-install-recommends cmake -y \
    && wget https://www.mpich.org/static/downloads/3.4.3/mpich-3.4.3.tar.gz \
    && tar zxvf mpich-3.4.3.tar.gz \
    && mv mpich-3.4.3 mpich \
    && cd mpich \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-device=ch4:ofi --disable-fortran --enable-cxx \
    && make \
    && make install \
    && cd .. \
    && pip3 install --no-cache-dir psutil \
    && wget https://github.com/HDFGroup/hdf5/archive/refs/tags/hdf5-1_13_0.tar.gz \
    && tar zxvf hdf5-1_13_0.tar.gz \
    && mv hdf5-hdf5-1_13_0 hdf5 \
    && cd hdf5 \
    && ./autogen.sh \
    && CC=mpicc ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/hdf5 --enable-parallel --enable-threadsafe --enable-unsupported \
    && make -j 8 \
    && make install \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && apt-get autoclean && rm mpich-3.4.3.tar.gz
