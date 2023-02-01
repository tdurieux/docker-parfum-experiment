FROM debian:stretch-slim

RUN \
        set -ex \
    && \
        apt-get update && apt-get install -y \
            build-essential \
            libcurl4-openssl-dev \
            git \
            cmake \
            libssl-dev \
            valgrind \
            libglib2.0-dev
