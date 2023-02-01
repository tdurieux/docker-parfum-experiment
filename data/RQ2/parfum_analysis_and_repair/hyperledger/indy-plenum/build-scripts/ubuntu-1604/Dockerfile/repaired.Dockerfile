FROM ubuntu:16.04

RUN apt-get update -y && apt-get install --no-install-recommends -y \
        apt-transport-https \
        ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    # common stuff
        git \
        wget \
        unzip \
        python3.5 \
        python3-pip \
        python3-venv \
    # fpm
        ruby \
        ruby-dev \
        rubygems \
        gcc \
        make \
    # rocksdb python wrapper
        libbz2-dev \
        zlib1g-dev \
        liblz4-dev \
        libsnappy-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --no-cache-dir -U \
    pip \
    'setuptools<=50.3.2'

# install fpm
RUN gem install --no-ri --no-rdoc rake fpm

WORKDIR /root

ADD . /root
