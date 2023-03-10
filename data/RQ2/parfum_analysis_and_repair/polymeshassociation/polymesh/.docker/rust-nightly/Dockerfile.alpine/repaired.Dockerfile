ARG rustbase=1.61.0
FROM rust:${rustbase}-alpine

ARG toolchainversion=nightly-2022-05-10
ENV TOOLCHAIN="${toolchainversion}"

RUN apk add --no-cache \
        bash \
        ca-certificates \
        clang \
        clang-dev \
        cmake \
        g++ \
        gcc \
        jq \
        libressl-dev \
        openssl-dev \
        make \
        pkgconfig \
        rsync
RUN rustup toolchain install $TOOLCHAIN && \
        rustup target add wasm32-unknown-unknown --toolchain $TOOLCHAIN