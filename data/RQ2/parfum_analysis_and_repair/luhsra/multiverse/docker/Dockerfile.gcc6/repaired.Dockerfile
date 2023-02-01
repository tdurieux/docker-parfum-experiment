FROM ubuntu:16.10

WORKDIR /src

# install compiler toolchain
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    gcc-6 \
    gcc-6-plugin-dev \
    g++-6 \
    make && rm -rf /var/lib/apt/lists/*;

# clean up to reduce image size
RUN apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

# set environment variables
ENV CC=gcc-6
ENV MY_CC=gcc-6
ENV CXX=g++-6

CMD make clean && make
