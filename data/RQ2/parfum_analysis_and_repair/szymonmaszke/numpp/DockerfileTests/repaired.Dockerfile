FROM ubuntu:18.04 AS test
LABEL maintainer="a395ux91 (vyzyv) <vyz@protonmail.com>"

COPY . /usr/include/numpp

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            gcc \
            g++ \
            ca-certificates \
            libeigen3-dev \
            libgsl-dev \
            libomp-dev \
            libgmp-dev \
            cmake \
            bc \
            git && \
    git clone https://github.com/symengine/symengine /tmp/symengine && rm -rf /var/lib/apt/lists/*;

WORKDIR /tmp/symengine
RUN cmake . && make && make install

