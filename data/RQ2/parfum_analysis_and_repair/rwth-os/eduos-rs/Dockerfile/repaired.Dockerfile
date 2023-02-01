# Download base image ubuntu 20.04
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Update Software repository
RUN apt-get -qq update && apt-get install --no-install-recommends -y apt-transport-https curl wget vim nano git binutils autoconf automake make cmake qemu-kvm qemu-system-x86 nasm gcc g++ build-essential libtool bsdmainutils lld-8 && rm -rf /var/lib/apt/lists/*; # Install required packets from ubuntu repository


# Install Rust toolchain
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly
RUN /root/.cargo/bin/rustup component add rust-src
RUN /root/.cargo/bin/rustup component add llvm-tools-preview
RUN /root/.cargo/bin/cargo install --git https://github.com/RWTH-OS/ehyve.git

ENV PATH="/root/.cargo/bin:/root/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/bin/:${PATH}"
ENV EDITOR=vim

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
