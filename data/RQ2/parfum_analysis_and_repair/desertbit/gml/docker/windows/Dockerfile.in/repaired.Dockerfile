FROM ubuntu:20.04
MAINTAINER team@desertbit.com

# Install dependencies.
# https://mxe.cc/#requirements
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y update && \
    apt-get -y --no-install-recommends install \
        sudo \
        nano \
        autoconf \
        automake \
        autopoint \
        bash \
        bison \
        bzip2 \
        flex \
        g++ \
        g++-multilib \
        gettext \
        git \
        gperf \
        intltool \
        libc6-dev-i386 \
        libgdk-pixbuf2.0-dev \
        libltdl-dev \
        libssl-dev \
        libtool-bin \
        libxml-parser-perl \
        lzip \
        make \
        openssl \
        p7zip-full \
        patch \
        perl \
        pkg-config \
        python \
        ruby \
        sed \
        unzip \
        wget \
        xz-utils && \
    apt-get -y clean && rm -rf /var/lib/apt/lists/*;

#import common/base

# https://mxe.cc
# https://stackoverflow.com/questions/14170590/building-qt-5-on-linux-for-windows/14170591#14170591
# Version 2.4.8
RUN export MXE_COMMIT="b989c665c243e7e370dfd36fee9b1198a24a0a23" && \
    git clone https://github.com/mxe/mxe.git /mxe && \
    cd /mxe && \
    git checkout "${MXE_COMMIT}"
