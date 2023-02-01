# wlisac/armv7hf-ubuntu-swift:5.0-bionic

ARG BASE_IMAGE=balenalib/armv7hf-ubuntu:bionic

# Download and decompress the tarball into an intermediate container
# to improve cache accross different base image variations

FROM balenalib/armv7hf-ubuntu:bionic as downloader

LABEL Description="Swift Downloader"

ARG TARBALL_URL=https://github.com/uraimo/buildSwiftOnARM/releases/download/5.0/swift-5.0-threads_hotfix-RPi23-Ubuntu1804.tgz
ARG TARBALL_FILE=swift.tgz

WORKDIR /swift

RUN curl -L -o $TARBALL_FILE $TARBALL_URL \
    && tar -xvzf $TARBALL_FILE -C /swift \
    && rm $TARBALL_FILE

# Create base image

FROM "$BASE_IMAGE"

LABEL maintainer "Will Lisac <will@lisac.org>"
LABEL Description="Docker Container for Swift on Balena"

# Dependencies from official Swift Dockerfile for Swift 5.0 on Ubuntu 18.04
# https://github.com/apple/swift-docker/blob/6812f217b405a5101ea3e8fce4d1cf09e3c8727b/5.0/ubuntu/18.04/Dockerfile

# Needed to add clang
# https://github.com/uraimo/buildSwiftOnARM/blob/1be3c13d709724b48b418c6511a38c8f323378ec/README.md#dependencies

RUN install_packages \
    libatomic1 \
    libbsd0 \
    libcurl4 \
    libxml2 \
    libedit2 \
    libsqlite3-0 \
    libc6-dev \
    binutils \
    libgcc-5-dev \
    libstdc++-5-dev \
    libpython2.7 \
    tzdata \
    git \
    pkg-config \
    clang

# Copy files from downloader to root
COPY --from=downloader /swift /

RUN swift --version
