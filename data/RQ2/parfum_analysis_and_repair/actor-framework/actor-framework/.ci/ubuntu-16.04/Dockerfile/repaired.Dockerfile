FROM ubuntu:16.04

RUN apt update -y \
    && apt upgrade -y \
    && apt install --no-install-recommends -y \
         clang-8 \
         cmake \
         git \
         libc++-8-dev \
         libc++abi-8-dev \
         libssl-dev \
         make \
    && apt autoclean && rm -rf /var/lib/apt/lists/*;

ENV CXX=/usr/bin/clang++-8
ENV CXXFLAGS=-stdlib=libc++
