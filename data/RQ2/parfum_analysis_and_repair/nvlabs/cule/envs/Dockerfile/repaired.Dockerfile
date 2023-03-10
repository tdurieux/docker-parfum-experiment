FROM nvidia/cuda:11.4.2-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=US

RUN apt-get -y update -qq && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        clang \
        gcc \
        cmake \
        htop \
        curl \
        git \
        libomp-dev \
        libsm6 \
        libssl-dev \
        libxrender-dev \
        libxext-dev \
        iproute2 \
        python3.8 \
        python3-dev \
        python3-setuptools \
        python3-pip \
        vim \
        ssh \
        wget \
        vim \
        zip \
    && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s /usr/bin/python3.8 /usr/bin/python
ENV LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64"

RUN pip install --no-cache-dir --upgrade cython \
                          cloudpickle \
                          gym[atari] \
                          opencv-python \
                          psutil \
                          torch==1.10.0 \
                          torchvision==0.11.1 \
                          tqdm

RUN git clone -b develop --recursive https://github.com/NVLabs/cule && \
    cd cule && \
    python setup.py install
