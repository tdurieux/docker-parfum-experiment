FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive
LABEL maintainer="Oxford Nanopore Technologies"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN \
    apt update \
    && apt install -yq --no-install-recommends \
        ca-certificates build-essential cmake curl wget git \
        zlib1g-dev libbz2-dev liblzma-dev libncurses5-dev libcurl4-gnutls-dev \
        libssl-dev libffi-dev \
        libreadline8 libreadline-dev sqlite3 libsqlite3-dev file \
        python3-all-dev python3-venv python3-pip python3-setuptools \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 10 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY . /tmp/medaka
RUN \
    cd /tmp/medaka \
    && make install_root \
    && cd / \
    && rm -rf /tmp/medaka \
