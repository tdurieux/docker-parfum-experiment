# used to cache installed dependencies for bionic builds
# this speeds up builds during development, as the dependencies are just installed _once_

FROM ubuntu:bionic

RUN apt-get update && \
    apt-get -y --no-install-recommends install qt5-default \
        qtbase5-dev \
        qt5-qmake \
        libcurl4-openssl-dev \
        libfuse-dev \
        desktop-file-utils \
        libglib2.0-dev \
        libcairo2-dev \
        libssl-dev \
        ca-certificates \
        libbsd-dev \
        qttools5-dev-tools \
        \
        gcc \
        g++ \
        cmake \
        make \
        git \
        automake \
        autoconf \
        libtool \
        patch \
        wget \
        vim-common \
        desktop-file-utils \
        pkg-config \
        libarchive-dev \
        libboost-filesystem-dev
