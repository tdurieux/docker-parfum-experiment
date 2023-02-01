# This should be run from the zef repo root
FROM python:3.7-slim

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
    jq && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN bash compile_for_local_dev.sh

ENV PYTHONPATH=/root/project/python