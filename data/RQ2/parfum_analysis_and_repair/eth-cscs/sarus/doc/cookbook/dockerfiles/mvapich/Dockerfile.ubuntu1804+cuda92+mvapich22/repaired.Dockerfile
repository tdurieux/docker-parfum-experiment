#!/bin/sh
FROM nvidia/cuda:9.2-devel-ubuntu18.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bison \
        file \
        g++ \
        gcc \
        gfortran \
        libibverbs-dev \
        make \
        perl-modules \
        wget \
        coreutils \
        strace \
    && rm -rf /var/lib/apt/lists/*

# ABI/12.0 requires mvapich<2.x (mvapich/2.3=abi/12.1)
RUN wget -q https://mvapich.cse.ohio-state.edu/download/mvapich/mv2/mvapich2-2.2.tar.gz \
    && tar xf mvapich2-*.tar.gz \
    && cd mvapich2-* \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local --disable-mcast --disable-xrc \
    && make -j6 \
    && make install \
    && ldconfig \
    && cd .. \
    && rm -rf mvapich2-* && rm mvapich2-*.tar.gz

# we need to disable Cross Memory Attach (CMA), otherwise mpiexec fails
ENV MV2_SMP_USE_CMA=0

# ubuntu/18.04 bionic -> gcc/6.5, gcc/7.4 (=default), gcc/8.3 (+ clang-7)
# -----------------   gcc/4   gcc/5   gcc/6   gcc/7   gcc/8   gcc/9
# cuda/09.2 < gcc/8   Y       Y       Y       Y       -       -
# cuda/10.0 < gcc/8   Y       Y       Y       Y       -       -
# cuda/10.1 < gcc/9   Y       Y       Y       Y       Y       -
RUN apt update && apt install -y g++-7 g++-8 --no-install-recommends && rm -rf /var/lib/apt/lists/*;

# ppa -> gcc/9.1
# https://launchpad.net/~ubuntu-toolchain-r/+archive/ubuntu/test?field.series_filter=bionic
RUN apt install --no-install-recommends -y software-properties-common \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && apt update \
    && apt install --no-install-recommends -y g++-9 && rm -rf /var/lib/apt/lists/*;
