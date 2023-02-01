FROM ubuntu:focal
MAINTAINER Jan Bujak (j@exia.io)

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends ca-certificates file gcc g++ git locales make qemu-user curl yarnpkg && rm -rf /var/lib/apt/lists/*;

RUN locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID user && useradd --uid $UID -g user -ms /bin/bash user

COPY static/run-if-enabled /usr/local/bin
COPY static/runner /usr/local/bin

RUN chmod +x /usr/local/bin/run-if-enabled
RUN chmod +x /usr/local/bin/runner

ARG TARGET_LIST="aarch64-unknown-linux-gnu mips64-unknown-linux-gnuabi64 armv7-unknown-linux-gnueabihf"
RUN run-if-enabled aarch64-unknown-linux-gnu "apt-get install -y --no-install-recommends g++-aarch64-linux-gnu libc6-dev-arm64-cross"
RUN run-if-enabled armv7-unknown-linux-gnueabihf "apt-get install -y --no-install-recommends g++-arm-linux-gnueabihf libc6-dev-armhf-cross"
RUN run-if-enabled mips64-unknown-linux-gnuabi64 "apt-get install -y --no-install-recommends g++-mips64-linux-gnuabi64 libc6-dev-mips64-cross"

ARG IS_INTERACTIVE=0
RUN [ $IS_INTERACTIVE -eq 0 ] || (mkdir /mnt/host && sed -i 's/root:\*/root:$6$Fc5teNQbSppq8I57$A1f7wwDpDKyHzb.0OPW6fpASde7sFtdiAA.2AZakKR8\/vQ8WiRySJBY2Ueyk0N0O2FqEkaGRFakwgSH.kodG2\//' /etc/shadow)

USER user
WORKDIR /home/user
ENV USER=user \
    PATH=/home/user/.cargo/bin:$PATH

RUN mkdir -p \
    /home/user/.cargo/bin \
    /home/user/.cargo/git \
    /home/user/.cargo/registry

COPY static/cargo.config /home/user/.cargo/config

ENV RUST_BACKTRACE=1

ARG USE_HOST_RUSTC=0
RUN [ $USE_HOST_RUSTC -eq 1 ] || curl -f https://static.rust-lang.org/rustup/archive/1.24.1/x86_64-unknown-linux-gnu/rustup-init > rustup-init
RUN [ $USE_HOST_RUSTC -eq 1 ] || chmod +x rustup-init
RUN [ $USE_HOST_RUSTC -eq 1 ] || ./rustup-init --profile minimal --default-toolchain nightly-2021-06-08 -y
RUN [ $USE_HOST_RUSTC -eq 1 ] || run-if-enabled aarch64-unknown-linux-gnu "rustup target add aarch64-unknown-linux-gnu"
RUN [ $USE_HOST_RUSTC -eq 1 ] || run-if-enabled armv7-unknown-linux-gnueabihf "rustup target add armv7-unknown-linux-gnueabihf"
RUN [ $USE_HOST_RUSTC -eq 1 ] || run-if-enabled mips64-unknown-linux-gnuabi64 "rustup target add mips64-unknown-linux-gnuabi64"

ARG CARGO_TARGET_DIR=/home/user/cwd/target-docker
ENV CARGO_TARGET_DIR=$CARGO_TARGET_DIR
