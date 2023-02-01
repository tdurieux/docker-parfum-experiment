# Build Stage
FROM rustlang/rust:nightly-slim AS builder
USER 0:0
WORKDIR /home/rust/src

# Install build requirements
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev pkg-config && rm -rf /var/lib/apt/lists/*;

# Build all crates
COPY Cargo.toml Cargo.lock ./
COPY crates ./crates
RUN cargo build --locked --release
