# -*- mode: dockerfile -*-

FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu16.04

ARG PYTHON_VERSION=3.8
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -yq \
        apt-transport-https \
        bison \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        flex \
        git \
        libbz2-dev \
        ninja-build \
        software-properties-common \
        wget && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/conda_setup

RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
        | gpg --batch --dearmor - \
        > /usr/share/keyrings/kitware-archive-keyring.gpg

RUN echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ xenial main' \
        > /etc/apt/sources.list.d/kitware.list

RUN apt-get update -o Acquire::https::apt.kitware.com::Verify-Peer=false

RUN apt-get install --no-install-recommends -yq -o Acquire::https::apt.kitware.com::Verify-Peer=false \
        cmake kitware-archive-keyring && rm -rf /var/lib/apt/lists/*;

RUN curl -f -o miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
        chmod +x miniconda.sh && \
        ./miniconda.sh -b -p /opt/conda && \
        /opt/conda/bin/conda install -y python=$PYTHON_VERSION && \
        /opt/conda/bin/conda clean -ya
ENV PATH /opt/conda/bin:$PATH

RUN python -m pip install --upgrade pip ipython ipdb

COPY . /opt/nle/

WORKDIR /opt/nle

RUN pip install --no-cache-dir '.[all]'

WORKDIR /workspace

CMD ["/bin/bash"]


# Docker commands:
#   docker rm nle -v
#   docker build -t nle -f docker/Dockerfile-xenial .
#   docker run --gpus all --rm --name nle nle
# or
#   docker run --gpus all -it --entrypoint /bin/bash nle
