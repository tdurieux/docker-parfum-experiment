FROM debian:buster-slim

ENV CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUSTUP_HOME=/usr/local/rustup \
    RUSTUP_VERSION=1.21.1 \
    RUSTUP_SHA256=ad1f8b5199b3b9e231472ed7aa08d2e5d1d539198a15c5b1e53c746aad81d27b
# Make sure this is in sync with buildkite-hooks/rust-toolchain!
ENV RUST_VERSION=nightly-2020-01-08

# This is where CI mounts the persistent cache
VOLUME /cache

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gcc \
        libc6-dev \
        libssl-dev \
        pkg-config \
        jq \
        curl \
        dpkg \
        liblzma-dev \
        ; \
    curl -LOf "https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/x86_64-unknown-linux-gnu/rustup-init"; \
    echo "${RUSTUP_SHA256}  *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version; \
    rustup component add clippy rustfmt; \
    cargo install sccache cargo-deb; \
    apt-get autoremove; \
    rm -rf /var/lib/apt/lists/*; \
    rm -rf /usr/local/cargo/registry; \
    rm /usr/local/cargo/.package-cache;

ENV SCCACHE_DIR=/cache/sccache \
    RUSTC_WRAPPER=sccache \
    CARGO_HOME=/cache/cargo

