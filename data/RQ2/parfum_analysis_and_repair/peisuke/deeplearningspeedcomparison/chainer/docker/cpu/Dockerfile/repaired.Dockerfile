FROM ubuntu:16.04

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    wget \
    sudo \
    vim \
    python3 \
    python3-dev \
    python3-pip \
    python3-wheel \
    python3-setuptools && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN pip3 install --no-cache-dir --upgrade pip

RUN pip3 install --no-cache-dir numpy \
    pandas \
    matplotlib \
    pillow \
    tqdm \
    chainer==4.4.0
