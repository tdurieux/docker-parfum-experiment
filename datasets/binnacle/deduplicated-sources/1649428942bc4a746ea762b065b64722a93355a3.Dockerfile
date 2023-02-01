# wlisac/armv7hf-ubuntu-swift:4.2.3-bionic

ARG BASE_IMAGE=balenalib/armv7hf-ubuntu:bionic

# Download and decompress the tarball into an intermediate container
# to improve cache accross different base image variations

FROM balenalib/armv7hf-ubuntu:bionic as downloader

LABEL Description="Swift Downloader"

ARG TARBALL_URL=https://github.com/uraimo/buildSwiftOnARM/releases/download/4.2.3/swift-4.2.3-RPi23-Ubuntu1804.tgz
ARG TARBALL_FILE=swift.tgz

WORKDIR /swift

RUN curl -L -o $TARBALL_FILE $TARBALL_URL \
    && tar -xvzf $TARBALL_FILE -C /swift \
    && rm $TARBALL_FILE

# Create base image

FROM "$BASE_IMAGE"

LABEL maintainer "Will Lisac <will@lisac.org>"
LABEL Description="Docker Container for Swift on Balena"

# Dependencies from official Swift Dockerfile for Swift 4.2 on Ubuntu 18.04
# https://github.com/apple/swift-docker/blob/6812f217b405a5101ea3e8fce4d1cf09e3c8727b/4.2/ubuntu/18.04/Dockerfile

RUN install_packages \
    make \
    libc6-dev \
    clang-3.9 \
    curl \
    libedit-dev \
    libpython2.7 \
    libicu-dev \
    libssl-dev \
    libxml2 \
    tzdata \
    git \
    libcurl4-openssl-dev \
    pkg-config \
    && update-alternatives --quiet --install /usr/bin/clang clang /usr/bin/clang-3.9 100 \
    && update-alternatives --quiet --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.9 100

# Copy files from downloader to root
COPY --from=downloader /swift /

RUN swift --version
