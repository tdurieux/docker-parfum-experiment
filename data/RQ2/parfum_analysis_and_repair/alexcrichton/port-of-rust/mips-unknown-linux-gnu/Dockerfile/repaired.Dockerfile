FROM ubuntu:16.04

RUN apt-get -y update && apt-get -y --no-install-recommends install curl file gcc gcc-mips-linux-gnu && rm -rf /var/lib/apt/lists/*;

ENV CARGO_HOME=/usr/local/cargo \
    RUSTUP_HOME=/usr/local/rustup \
    PATH=/usr/local/cargo/bin:$PATH
COPY support/install-rust.sh /tmp/
RUN sh /tmp/install-rust.sh mips-unknown-linux-gnu
COPY mips-unknown-linux-gnu/cargo-config /.cargo/config
