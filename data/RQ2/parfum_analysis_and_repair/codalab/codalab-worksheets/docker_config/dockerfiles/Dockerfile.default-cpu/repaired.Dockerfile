FROM ubuntu:20.04
MAINTAINER CodaLab Team "codalab.worksheets@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
    software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa


############################################################
# Common steps (must be the same in the CPU and GPU images)

RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-transport-https \
    iputils-ping \
    git \
    curl \
    build-essential \
    cmake \
    libhdf5-dev \
    swig \
    wget \
    python3.6 \
    python3.6-venv \
    python3.6-dev \
    python3-pip \
    python3-software-properties \
    openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

# Set Python3.6 as the default python version
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.6 1

RUN curl -f https://bootstrap.pypa.io/pip/3.6/get-pip.py | python3.6

### Without this Python thinks we're ASCII and unicode chars fail
ENV LANG C.UTF-8

## Python packages
RUN pip3 install --no-cache-dir -U pip
RUN python3 -m pip install -U --no-cache-dir \
      numpy \
      scipy \
      matplotlib \
      pandas \
      sympy \
      nose \
      spacy \
      tqdm \
      wheel \
      scikit-learn \
      scikit-image \
      nltk \
      tensorflow==1.12.0 \
      tensorboard \
      keras \
      torch==1.1.0 \
      torchvision

RUN python3 -m spacy download en_core_web_sm

# Check to make sure python works from the command line
RUN python
