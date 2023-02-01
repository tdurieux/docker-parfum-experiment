FROM debian:9

RUN apt update -y \
    && apt upgrade -y \
    && apt install --no-install-recommends -y \
         clang-7 \
         cmake \
         git \
         libc++-7-dev \
         libc++abi-7-dev \
         libprotobuf-dev \
         libssl-dev \
         make \
    && apt autoclean && rm -rf /var/lib/apt/lists/*;

ENV CXX=/usr/bin/clang++-7
ENV CXXFLAGS=-stdlib=libc++
