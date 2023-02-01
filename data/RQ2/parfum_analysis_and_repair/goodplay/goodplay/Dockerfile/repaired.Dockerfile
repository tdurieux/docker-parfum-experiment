FROM docker:latest

MAINTAINER Benjamin Schwarze <benjamin.schwarze@mailboxd.de>

RUN apk add --no-cache \
    gcc \
    git \
    libffi-dev \
    make \
    musl-dev \
    openssl-dev \
    perl \
    py-pip \
    python \
    python-dev \
    sshpass \
    wget

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir goodplay
