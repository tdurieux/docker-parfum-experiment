# -*- mode: dockerfile -*-
# Copyright (c) Facebook, Inc. and its affiliates.

FROM ubuntu:20.04

ARG PYTHON_VERSION=3.8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -yq \
        bison \
        build-essential \
        cmake \
        curl \
        flex \
        git \
        libbz2-dev \
        libncurses5 \
        libncurses5-dev \
        ninja-build \
        wget && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/conda_setup

RUN curl -f -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     chmod +x miniconda.sh && \
     ./miniconda.sh -b -p /opt/conda && \
     /opt/conda/bin/conda install -y python=$PYTHON_VERSION && \
     /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/bin:$PATH

RUN python -m pip install --upgrade pip ipython ipdb

RUN pip install --no-cache-dir pybind11 numpy gym

COPY . /opt/nle/

WORKDIR /opt/nle

RUN apt-get install --no-install-recommends -yq valgrind && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/nle

RUN rm -rf build

WORKDIR /opt/nle/build

RUN cmake -G Ninja -DCMAKE_BUILD_TYPE=debug ..

RUN ninja && ninja install

ENV LD_LIBRARY_PATH /opt/nle/build

ENV NETHACKOPTIONS name:Agent-mon-hum-neu-mal

CMD ["/bin/sh", "-c", "valgrind --leak-check=yes --leak-check=full --show-leak-kinds=all --log-file=valgrind.log --keep-debuginfo=yes ./rlmain r && cat valgrind.log"]

# Docker commands:
#   docker rm nle -v
#   docker build -t nle -f docker/Dockerfile.valgrind .
#   docker run --rm --name nle nle
# or
#   docker run -it --entrypoint /bin/bash nle
