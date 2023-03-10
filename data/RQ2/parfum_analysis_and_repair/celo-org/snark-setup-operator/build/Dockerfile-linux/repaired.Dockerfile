FROM rust:latest as cargo-build

RUN apt-get update && apt-get install --no-install-recommends musl-tools -y && rm -rf /var/lib/apt/lists/*;

RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /usr/src/main

COPY Cargo.lock Cargo.lock
COPY Cargo.toml Cargo.toml

RUN mkdir src/

RUN echo "fn main() {println!(\"if you see this, the build cache was invalidated\")}" > src/main.rs

RUN cargo build --release --target=x86_64-unknown-linux-musl

RUN rm -f target/x86_64-unknown-linux-musl/release/deps/snark-setup-operator*

COPY src ./src
COPY LICENSE .
COPY Cargo.lock .
COPY README.md .

RUN mkdir out
RUN cargo build --release --bin generate --target=x86_64-unknown-linux-musl && cp target/x86_64-unknown-linux-musl/release/generate out/generate-linux
RUN cargo build --release --bin contribute --target=x86_64-unknown-linux-musl && cp target/x86_64-unknown-linux-musl/release/contribute out/contribute-linux
RUN cargo build --release --bin generate --target=x86_64-unknown-linux-musl --no-default-features && cp target/x86_64-unknown-linux-musl/release/generate out/generate-linux-noasm
RUN cargo build --release --bin contribute --target=x86_64-unknown-linux-musl --no-default-features && cp target/x86_64-unknown-linux-musl/release/contribute out/contribute-linux-noasm
