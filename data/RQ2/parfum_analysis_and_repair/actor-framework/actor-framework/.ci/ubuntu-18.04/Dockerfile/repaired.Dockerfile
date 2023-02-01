FROM ubuntu:18.04

RUN apt update -y \
    && apt upgrade -y \
    && apt install --no-install-recommends -y \
         cmake \
         g++-8 \
         git \
         libssl-dev \
         make \
    && apt-get autoclean && rm -rf /var/lib/apt/lists/*;

ENV CXX=/usr/bin/g++-8
