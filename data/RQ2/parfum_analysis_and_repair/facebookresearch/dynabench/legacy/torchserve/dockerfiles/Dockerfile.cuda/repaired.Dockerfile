# Copyright (c) Facebook, Inc. and its affiliates.
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04

ENV PYTHONUNBUFFERED TRUE

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
    fakeroot \
    ca-certificates \
    dpkg-dev \
    g++ \
    python3.8-dev \
    python3-pip \
    openjdk-11-jdk \
    curl \
    vim \
    git \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

RUN cd /tmp \
    && curl -f -O https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py



# See https://pytorch.org/ for other options if you use a different version of CUDA
RUN pip install --no-cache-dir torch==1.6.0+cu101 torchvision==0.7.0+cu101 -f \
    https://download.pytorch.org/whl/torch_stable.html
RUN python -m pip install detectron2 -f \
    https://dl.fbaipublicfiles.com/detectron2/wheels/cu101/torch1.6/index.html
RUN pip install --no-cache-dir aiohttp
RUN pip install --no-cache-dir allennlp==0.8.4
RUN pip install --no-cache-dir zmq
RUN pip install --no-cache-dir pytorch_transformers
RUN pip install --no-cache-dir fairseq
RUN pip install --no-cache-dir captum


RUN pip install --no-cache-dir psutil

RUN pip install --no-cache-dir transformers==3.4.0
RUN pip install --no-cache-dir git+git://github.com/facebookresearch/mmf.git@079f71d8c217001fd0a88c2efd0cac51ad4b3aef

# Download and unzip glove for mmf
RUN mkdir -p /root/.cache/torch/mmf
RUN wget https://nlp.stanford.edu/data/glove.6B.zip -P /root/.cache/torch/mmf/
RUN unzip /root/.cache/torch/mmf/glove.6B.zip -d /root/.cache/torch/mmf/
RUN rm /root/.cache/torch/mmf/glove.6B.zip

RUN pip install --no-cache-dir torchserve torch-model-archiver

COPY dockerd-entrypoint.sh /usr/local/bin/dockerd-entrypoint.sh
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

RUN mkdir -p /home/model-server/ && mkdir -p /home/model-server/tmp
COPY config.properties /home/model-server/config.properties

WORKDIR /home/model-server
ENV TEMP=/home/model-server/tmp
ENV PYTHONIOENCODING=UTF-8

ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]
CMD ["serve"]
