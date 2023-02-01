# Builder
FROM rust:${{ROCKET_RUST_VERSION}} as builder
WORKDIR /usr/src

RUN rustup override set nightly

COPY . .
RUN cargo install --path .

# Minimalistic image