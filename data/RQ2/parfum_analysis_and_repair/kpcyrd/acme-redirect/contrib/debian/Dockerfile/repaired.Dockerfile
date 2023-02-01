FROM rust
RUN apt-get update && apt-get install --no-install-recommends -y build-essential pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN cargo install cargo-deb
