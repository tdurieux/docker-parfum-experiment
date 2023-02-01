FROM ubuntu:zesty

RUN \
        set -ex \
    && \
        apt-get update && apt-get install -y \
            apt-transport-https \
            curl \
            build-essential \
            libcurl4-openssl-dev \
            git \
            cmake \
            libssl-dev \
            valgrind \
            libglib2.0-dev \
