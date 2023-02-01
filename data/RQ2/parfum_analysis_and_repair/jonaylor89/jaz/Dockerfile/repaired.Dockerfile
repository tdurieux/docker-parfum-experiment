################## Stage 1 ####################

FROM rust:latest as builder 

COPY ./ ./

RUN cargo build --release

RUN mkdir -p /build-out

RUN cp target/release/jaz /build-out/

################## Stage 2 ####################