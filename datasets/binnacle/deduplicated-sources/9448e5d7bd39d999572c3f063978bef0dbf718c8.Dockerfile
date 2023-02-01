# Download base image ubuntu 18.04
FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Update Software repository
RUN apt-get -qq update

# Install required packets from ubuntu repository
RUN apt-get install -y apt-transport-https curl wget vim nano git binutils autoconf automake make cmake qemu-kvm qemu-system-x86 nasm gcc g++ build-essential libtool bsdmainutils

# Install Rust toolchain
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly
RUN /root/.cargo/bin/cargo install cargo-xbuild
RUN /root/.cargo/bin/rustup component add rust-src
RUN /root/.cargo/bin/cargo install --git https://github.com/RWTH-OS/ehyve.git

ENV PATH="/root/.cargo/bin:${PATH}"
ENV EDITOR=vim
