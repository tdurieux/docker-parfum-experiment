FROM ubuntu:16.04

MAINTAINER eric.t.dawson@gmail.com

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted universe multiverse" | tee -a /etc/apt/sources.list && apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    gcc-5-base \
    git \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone --recursive https://github.com/edawson/rkmh && \
    cd rkmh && git checkout dev && make && cp rkmh /usr/local/bin
