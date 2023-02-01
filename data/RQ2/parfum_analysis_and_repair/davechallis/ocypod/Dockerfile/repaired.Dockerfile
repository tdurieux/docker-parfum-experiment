# Statically compile with optimisations in the build image
FROM ekidd/rust-musl-builder:1.57.0 AS builder
COPY . ./
RUN sudo chown -R rust:rust /home/rust && cargo fetch
RUN cargo build --release

# Copy static binary from build image into minimal Debian-based image