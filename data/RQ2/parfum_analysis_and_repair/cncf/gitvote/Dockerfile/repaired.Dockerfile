# Build gitvote
FROM rust:1-alpine3.15 as builder
RUN apk --no-cache add musl-dev perl make
WORKDIR /gitvote
COPY src src
COPY templates templates
COPY Cargo.lock Cargo.lock
COPY Cargo.toml Cargo.toml
WORKDIR /gitvote/src
RUN cargo build --release

# Final stage