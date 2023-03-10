FROM ubuntu:18.04

LABEL org.opencontainers.image.source https://github.com/splunk/splunk-connect-for-ethereum
LABEL org.opencontainers.image.description "Image used for builds in CI of connector packages"

RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates software-properties-common build-essential apt-transport-https docker.io \
    && add-apt-repository ppa:git-core/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends git \
    && docker --version \
    && git --version \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install helm
RUN curl -f https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install node + yarn
RUN curl -f https://nodejs.org/dist/v14.16.0/node-v14.16.0-linux-x64.tar.gz | tar -xzf - -C /usr/local --strip-components=1 --no-same-owner \
    && node --version \
    && npm --version \
    && npm i -g yarn \
    && yarn --version && npm cache clean --force;

# Install rust toolchain + wasm-pack
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.50.0
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN rustup target add wasm32-unknown-unknown
RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh
