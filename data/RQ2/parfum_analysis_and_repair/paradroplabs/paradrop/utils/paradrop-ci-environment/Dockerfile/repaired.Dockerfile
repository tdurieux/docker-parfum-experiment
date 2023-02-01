FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        libffi-dev \
        libpulse0 \
        python \
        python-pip \
        snapcraft && \
    rm -rf /var/lib/apt/lists/*
