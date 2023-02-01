FROM rust:latest

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y mingw-w64 musl musl-tools make binutils upx && rm -rf /var/lib/apt/lists/*;

RUN rustup target add x86_64-pc-windows-gnu

RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /bhr