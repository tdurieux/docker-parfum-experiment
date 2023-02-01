### THIS DOESN'T WORK
###     but you could probably salvage it
###        after moving it into the parent directory


FROM rust AS builder
WORKDIR /var/BUGOUT
COPY src src
COPY Cargo.toml Cargo.toml
RUN cargo install --path .


FROM arm64v8/ubuntu:18.04

# includes path to libc -- find it with gcc --print-file-name=libc.a