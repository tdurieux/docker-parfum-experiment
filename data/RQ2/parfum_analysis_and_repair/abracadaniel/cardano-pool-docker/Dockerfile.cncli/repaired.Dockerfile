FROM debian:buster-slim as build
LABEL maintainer="dro@arrakis.it"

# Install build dependencies
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y automake build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 libtool autoconf \
    && apt-get install --no-install-recommends -y libsqlite3-dev m4 ca-certificates gcc libc6-dev curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install rust
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.47.0

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN cat /usr/local/cargo/env
RUN rustup install stable \
    && rustup default stable \
    && rustup update \
    && rustup component add clippy rustfmt

# Install cncli
ARG VERSION
RUN echo "Building tags/v$VERSION..." \
    && git clone --recurse-submodules https://github.com/AndrewWestberg/cncli \
    && cd cncli \
    && git fetch --all --recurse-submodules --tags \
    && git tag \
    && git checkout tags/v$VERSION \
    && cargo install --path . --force \
    && cncli --version

# Run
FROM arradev/cardano-node:latest AS node

FROM debian:stable-slim
SHELL ["/bin/bash", "-c"]

# Install dependencies
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y openssl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install compiled files
COPY --from=build /usr/local/cargo/bin/cncli /bin/cncli

ENTRYPOINT ["cncli"]