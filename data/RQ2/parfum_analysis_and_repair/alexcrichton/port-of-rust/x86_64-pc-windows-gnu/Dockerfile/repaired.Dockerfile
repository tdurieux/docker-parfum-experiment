FROM ubuntu:16.04

RUN apt-get -y update && apt-get -y --no-install-recommends install curl file gcc gcc-mingw-w64-x86-64 && rm -rf /var/lib/apt/lists/*;

ENV CARGO_HOME=/usr/local/cargo \
    RUSTUP_HOME=/usr/local/rustup \
    PATH=/usr/local/cargo/bin:$PATH
COPY support/install-rust.sh /tmp/
RUN sh /tmp/install-rust.sh x86_64-pc-windows-gnu
COPY x86_64-pc-windows-gnu/cargo-config /.cargo/config
