FROM ubuntu:16.04

WORKDIR /src

# install compiler toolchain
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    gcc-5 \
    gcc-5-plugin-dev \
    g++-5 \
    make && rm -rf /var/lib/apt/lists/*;

# clean up to reduce image size
RUN apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# set environment variables
ENV CC=gcc-5
ENV MY_CC=gcc-5
ENV CXX=g++-5

CMD make clean && make
