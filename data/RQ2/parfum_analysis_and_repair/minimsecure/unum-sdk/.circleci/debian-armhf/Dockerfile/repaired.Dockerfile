FROM arm32v7/debian:stretch-slim

# NOTE: This Dockerfile isn't actually used to create an image!
# Check the circleci config.yml in this repository for the code that actually
# generates the minimsecure/circleci-debian-armhf image.
# This file remains as a reference for what the CI steps should do.

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
