# Build the app
FROM rust:1.28.0 as builder

WORKDIR /app
COPY . .

RUN cargo build --release --target x86_64-unknown-linux-gnu


FROM debian:stretch-slim

# install openssl