FROM node:12.18-slim

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    ca-certificates \
    g++ \
    gcc \
    git \
    gzip \
    make \
    python \
    ruby-full \
    software-properties-common \
    ssh \
    sudo \
    tar \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -o /usr/bin/solc -fL https://github.com/ethereum/solidity/releases/download/v0.7.4/solc-static-linux \
    && chmod u+x /usr/bin/solc

