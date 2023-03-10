FROM nvidia/cuda:9.1-devel-ubuntu16.04
LABEL maintainer="dakkak@illinois.edu"

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update && apt-get install -y --no-install-recommends \
        gcc-6 \
        g++-6  \
        wget \
        unzip \
        apt-transport-https \
        ca-certificates \
    && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6 && \
    update-alternatives --config gcc && \
    gcc --version


ADD https://cmake.org/files/v3.10/cmake-3.10.1-Linux-x86_64.sh /tmp
RUN sh /tmp/cmake-3.10.1-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir