FROM ubuntu:latest

LABEL description="A docker image for kratos"
LABEL maintainer="keyi@cs.stanford.edu"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends git python3 \
            python3-pip verilator cmake python3-dev build-essential \
            python3-setuptools python3-wheel file valgrind clang-tidy clang lcov yosys && \
        ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
        dpkg-reconfigure --frontend noninteractive tzdata && \
        apt-get clean && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip