FROM pdal/pdal:2.2
MAINTAINER Connor Manning <connor@hobu.co>

RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    build-essential \
    cmake \
    git \
    liblzma-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    ninja-build \
    python3-dev \
    python3-numpy \
    vim \
    ca-certificates \
    curl \
    libgeotiff-dev \
    libgeotiff-epsg \
    libtiff5-dev \
    libproj-dev \
    libcurl4-openssl-dev \
    python3-pip \
    ninja-build \
    python3-setuptools \
    unzip \
    libzstd1-dev \
    pkg-config \
    libgdal-dev && \
    rm -rf /var/lib/apt/lists/*

ENV CC gcc
ENV CXX g++

RUN git clone https://github.com/jemalloc/jemalloc.git /var/jemalloc && \
    cd /var/jemalloc && \
    ./autogen.sh && \
    make dist && \
    make && \
    make install
ENV LD_PRELOAD /usr/local/lib/libjemalloc.so.2

