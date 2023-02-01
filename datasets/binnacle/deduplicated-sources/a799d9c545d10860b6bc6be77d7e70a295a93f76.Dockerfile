# wlisac/armv7hf-ubuntu-swift:4.2.3-xenial

ARG BASE_IMAGE=balenalib/armv7hf-ubuntu:xenial

# Download and decompress the tarball into an intermediate container
# to improve cache accross different base image variations

FROM balenalib/armv7hf-ubuntu:xenial as downloader

LABEL Description="Swift Downloader"

ARG TARBALL_URL=https://github.com/uraimo/buildSwiftOnARM/releases/download/4.2.3/swift-4.2.3-RPi23-Ubuntu1604.tgz
ARG TARBALL_FILE=swift.tgz

WORKDIR /swift

RUN curl -L -o $TARBALL_FILE $TARBALL_URL \
    && tar -xvzf $TARBALL_FILE -C /swift \
    && rm $TARBALL_FILE

# Create base image

FROM "$BASE_IMAGE"

LABEL maintainer "Will Lisac <will@lisac.org>"
LABEL Description="Docker Container for Swift on Balena"

# Dependencies from official Swift Dockerfile for Swift 4.2 on Ubuntu 16.04
# https://github.com/apple/swift-docker/blob/6812f217b405a5101ea3e8fce4d1cf09e3c8727b/4.2/ubuntu/16.04/Dockerfile

# Needed to replace libcurl4-openssl-dev with libcurl4-nss-dev
# https://github.com/uraimo/buildSwiftOnARM/tree/fc3ac47b2ce60b0098f44c7961f8295231698c99#dependencies

RUN install_packages \
    make \
    libc6-dev \
    clang-3.8 \
    curl \
    libedit-dev \
    libpython2.7 \
    libicu-dev \
    libssl-dev \
    libxml2 \
    tzdata \
    git \
    libcurl4-nss-dev \
    pkg-config \
    && update-alternatives --quiet --install /usr/bin/clang clang /usr/bin/clang-3.8 100 \
    && update-alternatives --quiet --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.8 100

# Copy files from downloader to root
COPY --from=downloader /swift /

RUN swift --version
