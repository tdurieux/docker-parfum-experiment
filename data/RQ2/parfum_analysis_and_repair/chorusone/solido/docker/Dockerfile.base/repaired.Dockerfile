FROM rust:1.60-slim-buster as base

# Install base tools
RUN apt -y update \
    && apt -y --no-install-recommends install libssl-dev libudev-dev pkg-config zlib1g-dev llvm clang make curl python3 gcc build-essential libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

