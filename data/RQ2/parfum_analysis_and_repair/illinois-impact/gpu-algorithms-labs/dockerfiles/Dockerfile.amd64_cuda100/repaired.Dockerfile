FROM nvidia/cuda:10.0-devel-ubuntu18.04
LABEL maintainer="pearson@illinois.edu"

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        software-properties-common && \
    apt-get update && apt-get install -y --no-install-recommends \
        wget \
        unzip \
        apt-transport-https \
        ca-certificates \
    && \
    rm -rf /var/lib/apt/lists/*


ADD https://github.com/Kitware/CMake/releases/download/v3.13.3/cmake-3.13.3-Linux-x86_64.sh /tmp
RUN sh /tmp/cmake-3.13.3-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir