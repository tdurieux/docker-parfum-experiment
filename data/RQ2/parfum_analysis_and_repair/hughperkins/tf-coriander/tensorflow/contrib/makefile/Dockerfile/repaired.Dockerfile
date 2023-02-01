FROM ubuntu:16.04

MAINTAINER Gunhan Gulsoy <gunan@google.com>

# Install make build dependencies for TensorFlow.
RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    curl \
    g++ \
    git \
    libtool \
    make \
    python \
    unzip \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;
