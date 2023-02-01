FROM ghcr.io/cross-rs/aarch64-unknown-linux-musl:main

RUN dpkg --add-architecture arm64 && \
    apt-get update && \
    apt-get install -y --no-install-recommends --assume-yes clang libclang-dev binutils-aarch64-linux-gnu && rm -rf /var/lib/apt/lists/*;
