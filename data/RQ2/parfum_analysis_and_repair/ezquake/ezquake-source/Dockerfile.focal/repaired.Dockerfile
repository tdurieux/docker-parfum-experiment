FROM ubuntu:20.04 as builder

ENV TZ=ETC/Utc
# hadolint ignore=DL3008
RUN DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    libcurl4-openssl-dev \
    libexpat1-dev \
    libfreetype6-dev \
    libjansson-dev \
    libjpeg-dev \
    libpng-dev \
    libsdl2-2.0-0 \
    libsdl2-dev \
    libsndfile-dev \
    libspeex-dev \
    libspeexdsp-dev \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /ezquake-source/
USER 1000