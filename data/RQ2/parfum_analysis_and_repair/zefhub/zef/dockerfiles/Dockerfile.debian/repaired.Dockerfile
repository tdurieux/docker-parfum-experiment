# This should be run from the zef repo root
FROM debian:stable

WORKDIR /root/project

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    make \
    ninja-build \
    curl \
    git \
    zstd \
    libzstd-dev \
    openssl \
    libssl-dev \
    libsecret-1-0 \
    libcurl4-openssl-dev \
    python3 \
    python3-pip \
    python3-dev \
    jq && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN LIBZEF_LOCATION=$(realpath core) pip3 --no-cache-dir install ./python
