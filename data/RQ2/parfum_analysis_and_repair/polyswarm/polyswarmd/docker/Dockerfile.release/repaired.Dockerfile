FROM ubuntu:xenial
LABEL maintainer="PolySwarm Developers <info@polyswarm.io>"

ARG POLYSWARMD_VERSION
ARG CONTRACTS_VERSION

WORKDIR /usr/src/app
COPY requirements.txt ./

# Python and build deps
RUN set -x && \
    apt-get update && apt-get install --no-install-recommends -y \
        curl \
        git \
        libgmp-dev \
        libssl-dev \
        python3 \
        python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Install solc
RUN set -x && \
    apt-get update && apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:ethereum/ethereum && \
    apt-get update && apt-get install --no-install-recommends -y \
        solc && \
    rm -rf /var/lib/apt/lists/*

# Install truffle
RUN set -x && \
    curl -sSf https://deb.nodesource.com/setup_9.x | bash - && \
    apt-get install --no-install-recommends -y \
        nodejs && \
    rm -rf /var/lib/apt/lists/* && \
    npm i -g truffle && npm cache clean --force;

# Install python deps
RUN set -x && \
    pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir pyinstaller

COPY . .

# Build contracts
RUN set -x && \
    git clone -b $CONTRACTS_VERSION https://github.com/polyswarm/contracts.git && \
    cd contracts && \
    npm i && \
    truffle compile && npm cache clean --force;

# Build ELF
RUN patch -d /usr/local/lib/python3.5/dist-packages -p1 < docker/release/site-packages.patch && \
    pyinstaller src/polyswarmd/__main__.py -n polyswarmd -y --clean && \
    mkdir -p dist/polyswarmd/config/contracts && \
    cp contracts/build/contracts/*.json dist/polyswarmd/config/contracts && \
    cp docker/release/polyswarmd.yml dist/polyswarmd/config

# Build tar
RUN cd dist && \
    mv polyswarmd polyswarmd-$POLYSWARMD_VERSION && \
    tar -czf /tmp/polyswarmd-$POLYSWARMD_VERSION.tar.gz polyswarmd-$POLYSWARMD_VERSION && rm /tmp/polyswarmd-$POLYSWARMD_VERSION.tar.gz
