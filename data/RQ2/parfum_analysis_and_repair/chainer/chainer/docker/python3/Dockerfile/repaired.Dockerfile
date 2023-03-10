FROM nvidia/cuda:9.2-cudnn7-devel

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    python3-dev \
    python3-pip \
    python3-wheel \
    python3-setuptools \
    git \
    cmake \
    libblas3 \
    libblas-dev \
    && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN CHAINER_BUILD_CHAINERX=1 CHAINERX_BUILD_CUDA=1 pip3 install --no-cache-dir 'numpy<1.19' cupy-cuda92==7.8.0 chainer==7.8.0