FROM rust:slim-bullseye AS build

RUN apt-get update && apt-get install --no-install-recommends -y build-essential clang && rm -rf /var/lib/apt/lists/*;

RUN rustup --version
RUN rustup component add rustfmt

RUN rustc --version && \
    rustup --version && \
    cargo --version

WORKDIR /app
COPY . /app
RUN cargo clean && cargo build --release --target x86_64-unknown-linux-gnu
RUN strip ./target/x86_64-unknown-linux-gnu/release/sonic

FROM debian:bullseye-slim

WORKDIR /usr/src/sonic

COPY --from=build /app/target/x86_64-unknown-linux-gnu/release/sonic /usr/local/bin/sonic

CMD [ "sonic", "-c", "/etc/sonic.cfg" ]

EXPOSE 1491
