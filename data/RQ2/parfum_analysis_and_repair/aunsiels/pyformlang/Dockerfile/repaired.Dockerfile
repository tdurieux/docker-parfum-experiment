FROM ubuntu:18.04

RUN export DEBIAN_FRONTEND=noninteractive

RUN apt-get update -yqq && \
    apt-get install --no-install-recommends -y tzdata && \
    apt-get -y --no-install-recommends -qq install \
    python3-setuptools \
    python3-dev \
    build-essential \
    python3-pip \
    pylint3 \
&& rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir --upgrade pip

WORKDIR /pyformlang_tests

RUN pip3 install --no-cache-dir pytest \
    pytest-cov \
    numpydoc \
    setuptools \
    wheel \
    twine \
    Tqdm \
    networkx \
    bitarray \
    numpy \
    pycodestyle \
    pydot
