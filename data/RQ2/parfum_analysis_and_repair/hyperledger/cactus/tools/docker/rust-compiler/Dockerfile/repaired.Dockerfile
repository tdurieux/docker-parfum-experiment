FROM rust:1.57.0-slim-bullseye

RUN apt update && apt install --no-install-recommends -y build-essential pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*; # wasm-pack dependencies+install

RUN cargo install wasm-pack
