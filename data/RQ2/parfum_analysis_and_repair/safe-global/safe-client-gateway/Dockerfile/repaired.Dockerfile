# Build Image
# match with version in rust-toolchain.toml file
FROM rust:1.62.0-slim-buster as builder

RUN set -ex; \ 
  apt-get update; \
  apt-get install -y --no-install-recommends \
  pkg-config ca-certificates libssl-dev \
  && rm -rf /var/lib/apt/lists/*

ENV USER=root
WORKDIR "/app"
# Cache dependencies
# We copy the toolchain requirements first. 
# This will make it possible that all the stages after the init can be cached.
COPY rust-toolchain.toml rust-toolchain.toml
RUN cargo init
COPY Cargo.toml Cargo.toml
COPY Cargo.lock Cargo.lock
RUN cargo build --release --locked

COPY . .

ARG VERSION
ARG BUILD_NUMBER
# Remove fingerprint of app to force recompile (without dependency recompile)
RUN rm -rf target/release/.fingerprint/safe-client-gateway*
RUN cargo build --release --locked

# Runtime Image