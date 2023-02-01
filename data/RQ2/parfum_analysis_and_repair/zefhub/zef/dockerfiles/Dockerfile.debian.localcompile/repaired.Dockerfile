# This should be run from the zef repo root
FROM debian:stable

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

RUN bash compile_for_local_dev.sh
