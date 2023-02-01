FROM ubuntu:17.04

WORKDIR /src

# add toolchain repository
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    software-properties-common \
    python-software-properties \
    && add-apt-repository ppa:ubuntu-toolchain-r/test && rm -rf /var/lib/apt/lists/*;

# install compiler toolchain
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    gcc-7 \
    gcc-7-plugin-dev \
    g++-7 \
    make && rm -rf /var/lib/apt/lists/*;

# clean up to reduce image size
RUN apt-get remove -y \
    software-properties-common \
    python-software-properties \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# set environment variables
ENV CC=gcc-7
ENV MY_CC=gcc-7
ENV CXX=g++-7

CMD make clean && make
