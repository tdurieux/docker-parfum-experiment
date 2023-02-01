ARG BASE_IMAGE
FROM ${BASE_IMAGE}

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    gnupg2 \
    wait-for-it \
    apt-transport-https \
    git \
    iproute2 \
    curl \
    dnsutils \
    iputils-ping \
    iproute2 \
    ca-certificates \
    net-tools \
    && rm -rf /var/lib/apt/lists/*
