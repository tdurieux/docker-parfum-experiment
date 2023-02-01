FROM rust:1.51.0 as builder

WORKDIR /rlink-rs

ADD ./ ./

COPY ./docker/config.toml .cargo/


RUN cargo build --bin rlink-example-simple --release

FROM ubuntu:20.04

RUN apt update && apt install --no-install-recommends openssl -y && rm -rf /var/lib/apt/lists/*;

COPY  --from=builder /rlink-rs/target/release/rlink-example-simple /usr/local/bin

ENTRYPOINT  ["rlink-example-simple"]