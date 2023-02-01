FROM debian:stretch-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        build-essential \
        git \
        libcurl4-openssl-dev \
        libjansson-dev \
        libnl-3-dev \
        libnl-genl-3-dev \
        libssl-dev \
        debhelper && rm -rf /var/lib/apt/lists/*;
