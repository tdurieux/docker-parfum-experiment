FROM ubuntu:21.04 AS base

# Install everything except cmake
RUN apt-get update && \
  apt-get -y upgrade &&\
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get install --no-install-recommends -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    fdkaac \
    git \
    gnupg \
    gnuradio \
    gnuradio-dev \
    gr-osmosdr \
    libboost-all-dev \
    libcurl4-openssl-dev \
    libgmp-dev \
    libhackrf-dev \
    liborc-0.4-dev \
    libpthread-stubs0-dev \
    libssl-dev \
    libuhd-dev \
    libusb-dev \
    pkg-config \
    software-properties-common \
    cmake \
    sox && \
  rm -rf /var/lib/apt/lists/*




# GNURadio requires a place to store some files, can only be set via $HOME env var.
ENV HOME=/tmp

CMD ["/usr/local/bin/trunk-recorder", "--config=/app/config.json"]
