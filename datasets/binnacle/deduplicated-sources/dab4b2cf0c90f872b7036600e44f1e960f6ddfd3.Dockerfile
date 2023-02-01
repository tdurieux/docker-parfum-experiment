FROM ubuntu:xenial

RUN \
        set -ex \
    && \
        apt-get update && apt-get install -y \
            build-essential \
            clang \
            git \
            cmake \
            valgrind \
            pkg-config \
            libssl-dev \
            libcurl4-openssl-dev \
    && \
        update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 \
    && \
        update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100
