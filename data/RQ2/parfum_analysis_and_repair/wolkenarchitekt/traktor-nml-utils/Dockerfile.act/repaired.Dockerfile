# Custom act builder as default builder does not support Python 3.9.1:
# https://github.com/nektos/act/issues/418
FROM ubuntu:20.04

RUN apt-get update \
    && apt-get upgrade -y \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
    build-essential \
    curl \
    nodejs \
    npm \
    sudo \
    && rm -rf /var/lib/apt/lists/*
