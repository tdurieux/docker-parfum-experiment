FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y curl file gcc gcc-powerpc64-linux-gnu && rm -rf /var/lib/apt/lists/*;

ENV CARGO_HOME=/usr/local/cargo \
    RUSTUP_HOME=/usr/local/rustup \
    PATH=/usr/local/cargo/bin:$PATH
COPY support/install-rust.sh /tmp/
RUN sh /tmp/install-rust.sh powerpc64-unknown-linux-gnu
COPY powerpc64-unknown-linux-gnu/cargo-config /.cargo/config
ENV CC_powerpc64_unknown_linux_gnu=powerpc64-linux-gnu-gcc
