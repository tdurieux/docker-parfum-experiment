FROM ubuntu:20.04

RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
    build-essential \
    wget \
    curl \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*
