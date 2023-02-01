FROM ubuntu:xenial
MAINTAINER Joel Martin <github@martintribe.org>

##########################################################
# General requirements for testing or common across many
# implementations
##########################################################

RUN apt-get -y update

# Required for running tests
RUN apt-get -y install make python

# Some typical implementation and test requirements
RUN apt-get -y install curl libreadline-dev libedit-dev

RUN mkdir -p /mal
WORKDIR /mal

##########################################################
# Specific implementation requirements
##########################################################

# Swift
RUN apt-get -y install clang-3.6 cmake pkg-config \
    git ninja-build uuid-dev libicu-dev icu-devtools \
    libbsd-dev libedit-dev libxml2-dev libsqlite3-dev \
    swig libpython-dev libncurses5-dev

# TODO: better way to do this?
RUN ln -sf /usr/lib/llvm-3.6/bin/clang++ /usr/bin/clang++
RUN ln -sf /usr/lib/llvm-3.6/bin/clang /usr/bin/clang

ENV SWIFT_PREFIX swift-3.0.1-PREVIEW-3
ENV SWIFT_RELEASE ${SWIFT_PREFIX}-ubuntu16.04

RUN cd /opt && \
    curl -O https://swift.org/builds/swift-3.0.1-preview-3/ubuntu1604/${SWIFT_PREFIX}/${SWIFT_RELEASE}.tar.gz && \
    tar xvzf ${SWIFT_RELEASE}.tar.gz && \
    rm ${SWIFT_RELEASE}.tar.gz

ENV PATH /opt/${SWIFT_RELEASE}/usr/bin/:$PATH


