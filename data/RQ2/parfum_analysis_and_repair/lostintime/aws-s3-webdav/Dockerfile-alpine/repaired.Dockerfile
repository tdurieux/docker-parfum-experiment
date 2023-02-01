# Build the app
FROM ekidd/rust-musl-builder:1.28.0 as builder

WORKDIR /home/rust/src

COPY . .

RUN cargo build --release --target x86_64-unknown-linux-musl

# Build using this image: https://hub.docker.com/r/ekidd/rust-musl-builder/
FROM alpine:3.8

# install openssl