#!/bin/sh
FROM nvidia/cuda:9.2-devel-ubuntu18.04

RUN apt update \
    && apt install -y \
        bison \
        file \
        g++ \
        gcc \
        gfortran \
        make \
        gdb \
        wget \
        strace \
        --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN cd /tmp \
    && wget -q https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.1.tar.gz \
    && tar xf openmpi-*.tar.gz \
    && cd openmpi-4.0.1 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-slurm=no --prefix=/usr/local \
    && echo A \
    && make -j3 all \
    && echo B \
    && make install \
    && echo C \
    && cd /tmp && rm -rf openmpi-* \
    && echo D \
    && ldconfig \
    && echo E && rm openmpi-*.tar.gz

# ubuntu/18.04 bionic -> gcc/6.5, gcc/7.4 (=default), gcc/8.3 (+ clang-7)
# -----------------   gcc/4   gcc/5   gcc/6   gcc/7   gcc/8   gcc/9
# cuda/09.2 < gcc/8   Y       Y       Y       Y       -       -
# cuda/10.0 < gcc/8   Y       Y       Y       Y       -       -
# cuda/10.1 < gcc/9   Y       Y       Y       Y       Y       -
RUN apt update && apt install -y g++-8 --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN echo F

# ppa -> gcc/9.1
# https://launchpad.net/~ubuntu-toolchain-r/+archive/ubuntu/test?field.series_filter=bionic
RUN apt install --no-install-recommends -y software-properties-common \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && apt update \
    && apt install --no-install-recommends -y g++-9 && rm -rf /var/lib/apt/lists/*;
RUN echo G
