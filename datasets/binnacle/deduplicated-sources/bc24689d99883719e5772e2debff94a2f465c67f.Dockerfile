# wlisac/armv7hf-debian-swift:5.0-stretch

ARG BASE_IMAGE=balenalib/armv7hf-debian:stretch

# Download and decompress the tarball into an intermediate container
# to improve cache accross different base image variations

FROM balenalib/armv7hf-debian:stretch as downloader

LABEL Description="Swift Downloader"

ARG TARBALL_URL=https://github.com/uraimo/buildSwiftOnARM/releases/download/5.0/swift-5.0-threads_hotfix-RPi23-RaspbianStretch.tgz
ARG TARBALL_FILE=swift.tgz

WORKDIR /swift

RUN curl -L -o $TARBALL_FILE $TARBALL_URL \
    && tar -xvzf $TARBALL_FILE -C /swift \
    && rm $TARBALL_FILE

# Create base image

FROM "$BASE_IMAGE"

LABEL maintainer "Will Lisac <will@lisac.org>"
LABEL Description="Docker Container for Swift on Balena"

# Started with dependencies from official Swift Dockerfile for Swift 5.0 on Ubuntu 16.04
# https://github.com/apple/swift-docker/blob/6812f217b405a5101ea3e8fce4d1cf09e3c8727b/5.0/ubuntu/16.04/Dockerfile

# Needed to add clang (not clang-3.8)
# https://github.com/uraimo/buildSwiftOnARM/blob/1be3c13d709724b48b418c6511a38c8f323378ec/README.md#dependencies

# Also, I was getting "Unable to locate package libgcc-5-dev" and "Unable to locate package libstdc++-5-dev"
# from the raw armv7hf base image. 
# I just removed these explicit dependencies since clang includes newer versions anyway.
# https://forums.swift.org/t/which-clang-package-should-we-install/20542/7
# Upgrading to libgcc-6-dev and libstdc++-6-dev explicitly would also be fine.

RUN install_packages \
    libatomic1 \
    libbsd0 \
    libcurl3 \
    libxml2 \
    libedit2 \
    libsqlite3-0 \
    libc6-dev \
    binutils \
    libpython2.7 \
    tzdata \
    git \
    pkg-config \
    clang

# Copy files from downloader to root
COPY --from=downloader /swift /

RUN swift --version
