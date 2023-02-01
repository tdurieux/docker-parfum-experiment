FROM ubuntu:16.04

RUN apt-get -y update && apt-get -y --no-install-recommends install curl file gcc && rm -rf /var/lib/apt/lists/*;

ENV CARGO_HOME=/usr/local/cargo \
    RUSTUP_HOME=/usr/local/rustup \
    PATH=/usr/local/cargo/bin:$PATH
COPY support/install-rust.sh /tmp/
RUN curl -f https://sh.rustup.rs | sh -s -- -y --default-toolchain=nightly
COPY x86_64-unknown-linux-gnu/cargo-config /.cargo/config
