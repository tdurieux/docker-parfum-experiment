# Container used to run integration tests.
FROM alpine:3.7

RUN apk add --no-cache --update \
    gettext \
    jq \
    groff \
    less \
    python \
    python-dev \
    py-pip \
    py-cffi \
    py-cryptography \
    gcc \
    libffi-dev \
    linux-headers \
    musl-dev \
    openssl \
    openssl-dev \
    curl \
    gzip \
    tar \
    ca-certificates \
    util-linux \
    coreutils \
    bash

RUN pip install --no-cache-dir \
    gsutil \
    awscli

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk && \
    apk add --no-cache glibc-2.23-r3.apk && \
    rm glibc-2.23-r3.apk

# Install kubectl
RUN curl -f -L -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl && \
    chmod +x /usr/bin/kubectl && \
    kubectl version --client

RUN rm /var/cache/apk/*
