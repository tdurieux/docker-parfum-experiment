# Dockerfile for building PyKaldi image from Ubuntu 18.04 image
FROM ubuntu:18.04

# Install necessary system packages
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    python3 \
    python3-pip \
    python2.7 \
    autoconf \
    automake \
    cmake \
    curl \
    g++ \
    git \
    graphviz \
    libatlas3-base \
    libtool \
    make \
    pkg-config \
    sox \
    subversion \
    unzip \
    wget \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# Make python3 default
RUN ln -s /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/bin/pip3 /usr/bin/pip

# Install necessary Python packages
RUN pip install --no-cache-dir --upgrade pip \
    numpy \
    setuptools \
    pyparsing \
    jupyter \
    ninja

# Copy pykaldi directory into the container
COPY . /pykaldi

# Install Protobuf, CLIF, Kaldi and PyKaldi
RUN cd /pykaldi/tools \
    && ./check_dependencies.sh \
    && ./install_protobuf.sh \
    && ./install_clif.sh \
    && ./install_kaldi.sh \
    && cd .. \
    && python setup.py install
