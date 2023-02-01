# This is an *unsupported* and *unofficial* Dockerfile.  The purpose of this Dockerfile is to demonstrate the steps
# required to have a working build system to build/install the Couchbase Python 4.x SDK.  No optimization has been
# done.
#
# Build System checklist:
#   - Compiler that supports C++ 17
#   - CMake >= 3.18
#   - OpenSSL >= 1.1.1
#   - Python >= 3.7
#
# The 4.0.2 release of the Couchbase Python SDK provides manylinux wheels.  A Python package wheel provides a pre-built
# binary that enables significantly faster install and users do not need to worry about setting up the appropriate
# build system (i.e. no need to install/update compiler and/or CMake).
#
# **NOTE:** All versions of the 4.x Python SDK, require OpenSSL >= 1.1.1 and Python >= 3.7
#
# Example usage:
#   build:
#       docker build -t <name of image> -f <path including Dockerfile> <path to Dockerfile directory>
#   run:
#       docker run --rm --name <name of running container> -it <name of image> /bin/bash
#

FROM --platform=linux/amd64 centos:centos8

# Update the following ARGs to desired specification

# CMake must be >= 3.18
ARG CMAKE_VERSION=3.19.8
# Python must be >= 3.7
ARG PYTHON_VERSION=3.8.10
# NOTE:  the Python version chosen will impact what python executable to use when pip
#           installing packages (see commands at bottom)
ARG PYTHON_EXE=python3.8
# OpenSSL must be >= 1.1.1
ARG OPENSSL_VERSION=1.1.1l
ARG COUCHBASE_PYTHON_SDK=4.0.2

# basic setup
RUN yum install -y python3-devel python3-pip python3-setuptools gcc gcc-c++ openssl openssl-devel cmake make && rm -rf /var/cache/yum

# OPTIONAL: useful tools
RUN yum install -y wget vim zip unzip && rm -rf /var/cache/yum
# OPTIONAL: more useful tools
# RUN yum install -y lsof lshw sysstat net-tools tar

# get the stdc++ static libs
RUN dnf install -y dnf-plugins-core && \
    dnf upgrade -y && \
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf config-manager --set-enabled powertools && \
    yum install -y glibc-static && \
    yum install -y libstdc++-static && rm -rf /var/cache/yum

# OPTIONAL: install/update CMake
#   - CentOS 8 *should* offer a compatible version of CMake (>= v3.18)
# RUN cd /tmp && \
#     curl -L -o cmake-$CMAKE_VERSION.tar.gz https://github.com/Kitware/CMake/releases/download/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz && \
#     tar xf cmake-$CMAKE_VERSION.tar.gz && \
#     cd cmake-$CMAKE_VERSION && \
#     ./bootstrap && \
#     make -j4 && \
#     make install

# OPTIONAL:  update OpenSSL
#   - CentOS 8 *should* come with a compatible version of OpenSSL (>= v1.1.1)
# RUN yum install -y pcre-devel zlib-devel gd-devel perl-ExtUtils-Embed libxslt-devel perl-Test-Simple
# RUN cd /usr/src && \
#     curl -L -o openssl-$OPENSSL_VERSION.tar.gz https://www.openssl.org/source/old/1.1.1/openssl-$OPENSSL_VERSION.tar.gz && \
#     tar -xvf openssl-$OPENSSL_VERSION.tar.gz && \
#     mv openssl-$OPENSSL_VERSION openssl && \
#     cd openssl && \
#     ./config --prefix=/usr/local/openssl --openssldir=/usr/local/openssl --libdir=/lib64 shared zlib-dynamic && \
#     make -j4 && \
#     make install && \
#     mv /usr/bin/openssl /usr/bin/openssl-backup && \
#     ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl

# install new Python version
RUN yum install -y libffi-devel && rm -rf /var/cache/yum
RUN cd /tmp && \
    curl -f -L -o Python-$PYTHON_VERSION.tgz https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz && \
    tar -xf Python-$PYTHON_VERSION.tgz && \
    cd Python-$PYTHON_VERSION && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-optimizations && \
    make altinstall && rm Python-$PYTHON_VERSION.tgz

# Install Couchbase Python SDK 4.x
RUN $PYTHON_EXE -m pip install --upgrade pip setuptools wheel
# To do a source install:
#   - make sure the build system has been setup appropriately
#   - use the --no-binary option to force an install from source
RUN $PYTHON_EXE -m pip install couchbase==$COUCHBASE_PYTHON_SDK --no-binary couchbase
