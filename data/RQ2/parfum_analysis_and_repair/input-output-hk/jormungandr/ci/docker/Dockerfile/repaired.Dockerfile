FROM rust:1.55-slim
RUN apt-get update && apt-get install --no-install-recommends -y pkg-config libssl-dev && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN cargo install cargo-audit
