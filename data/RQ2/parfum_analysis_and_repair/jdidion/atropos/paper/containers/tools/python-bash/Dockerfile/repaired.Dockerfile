#################################################################
# Dockerfile
#
# Software:         python
# Software Version: 3.6
# Description:      Python 3.6 pandas, seaborn, and other libraries
# Provides:         python
# Base Image:       phusion/baseimage
# Build Cmd:        docker build -f Dockerfile -t jdidion/python_bash .
# Pull Cmd:         docker pull jdidion/python_bash
# Run Cmd:          docker run --rm jdidion/python_bash python -h
#################################################################
FROM phusion/baseimage:latest
WORKDIR /tmp

ENV BUILD_PACKAGES \
    build-essential \
    g++ \
    gfortran \
    libbz2-dev \
    zlib1g-dev \
    liblzma-dev \
    libpng-dev \
    libfreetype6-dev \
    git
ENV RUNTIME_PACKAGES \
    libncurses5-dev \
    libncursesw5-dev \
    python3-pip \
    time

RUN apt-get update && apt-get install --no-install-recommends --yes \
        $BUILD_PACKAGES \
        $RUNTIME_PACKAGES \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir cython \
    && pip install --no-cache-dir editdistance \
    && pip install --no-cache-dir numpy \
    && pip install --no-cache-dir pandas \
    && pip install --no-cache-dir matplotlib \
    && pip install --no-cache-dir seaborn \
    && pip install --no-cache-dir mako \
    && pip install --no-cache-dir pysam \
    && pip uninstall --yes cython \
    && apt-get remove --purge -y $BUILD_PACKAGES \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*
