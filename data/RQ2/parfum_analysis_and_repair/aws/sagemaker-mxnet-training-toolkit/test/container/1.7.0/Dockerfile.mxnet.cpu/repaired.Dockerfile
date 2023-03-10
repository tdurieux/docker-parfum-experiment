FROM ubuntu:18.04

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    ca-certificates \
    curl \
    git \
    openssh-client \
    openssh-server \
    vim \
    wget \
    python3-dev \
    && ln -s -f /usr/bin/python3 /usr/bin/python \
    && ln -s /usr/local/bin/pip3 /usr/bin/pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# MXNet requires pip 19.3.1 due to being backwards compatible
# with python2
RUN cd /tmp && \
    curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py 'pip==19.1' && rm get-pip.py

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --no-cache mxnet==1.7.0.post1

COPY dist/sagemaker_mxnet_training-*.tar.gz /sagemaker_mxnet_training.tar.gz
RUN pip install --no-cache-dir /sagemaker_mxnet_training.tar.gz && \
    rm /sagemaker_mxnet_training.tar.gz

ENV SAGEMAKER_TRAINING_MODULE=sagemaker_mxnet_container.training:main

WORKDIR /
