FROM ubuntu:18.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        git \
        libbz2-dev \
        libc6-dev \
        libffi-dev \
        liblzma-dev \
        libsqlite3-dev \
        libssl-dev \
        make \
        pkg-config \
        wget \
        zlib1g-dev && rm -rf /var/lib/apt/lists/*;
