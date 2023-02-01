FROM ghcr.io/cross-rs/aarch64-unknown-linux-gnu:main

RUN dpkg --add-architecture arm64 && \
    apt-get update && \
    apt-get install -y --no-install-recommends --assume-yes clang-8 libclang-8-dev binutils-aarch64-linux-gnu && rm -rf /var/lib/apt/lists/*;
