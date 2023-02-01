FROM ubuntu:20.04

ENV DEBIAN_FRONTEND="noninteractive" TZ="America/Los_Angeles"

# A version field to invalide Cirrus's build cache when needed, as suggested in
# https://github.com/cirruslabs/cirrus-ci-docs/issues/544#issuecomment-566066822
ENV DOCKERFILE_VERSION 20220519

RUN apt-get update && apt-get -y install \
    bc \
    bison \
    bsdmainutils \
    ccache \
    cmake \
    curl \
    flex \
    g++ \
    gcc \
    git \
    lcov \
    libkrb5-dev \
    libmaxminddb-dev \
    libpcap-dev \
    libssl-dev \
    make \
    python3 \
    python3-dev \
    python3-pip\
    ruby \
    sqlite3 \
    swig \
    unzip \
    wget \
    zlib1g-dev \
  && rm -rf /var/lib/apt/lists/*

# Note - the symlink is important, otherwise cmake uses the wrong .so files.
RUN wget https://www.openssl.org/source/openssl-3.0.0.tar.gz && tar xvf ./openssl-3.0.0.tar.gz && cd ./openssl-3.0.0 && ./Configure --prefix=/opt/openssl && make install && cd .. && rm -rf openssl-3.0.0 && ln -sf /opt/openssl/lib64 /opt/openssl/lib

RUN pip3 install websockets junit2html
RUN gem install coveralls-lcov
