# BUILD
FROM rust:1.50-alpine

# we need to install one library on alpine
RUN apk add --no-cache musl-dev

WORKDIR /build/

# selection in .dockerignore
ADD . .

RUN (ls target/release/main && echo "already built") || cargo build --release

# RUN
# curl image is based on alpine, so we're compatible