FROM nvidia/cuda:10.2-devel-ubuntu18.04

MAINTAINER Ben Barsdell <benbarsdell@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

# Get dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        git \
        pkg-config \
        software-properties-common \
        python \
        python-dev \
        python-pip \
        doxygen \
        exuberant-ctags \
        nano \
        vim \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip --no-cache-dir install \
        setuptools \
        numpy \
        matplotlib \
        contextlib2 \
        simplejson \
        pint \
        ctypesgen==1.0.2 \
        graphviz

ENV TERM xterm

# Build the library
WORKDIR /bifrost

ENV LD_LIBRARY_PATH /usr/local/lib:${LD_LIBRARY_PATH}

# IPython
EXPOSE 8888

RUN ["/bin/bash"]