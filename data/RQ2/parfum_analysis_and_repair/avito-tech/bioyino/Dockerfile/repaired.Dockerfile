FROM rust:latest as builder

WORKDIR /usr/src/bioyino
COPY . .

RUN apt-get update && apt-get install --no-install-recommends capnproto -y && rm -rf /var/lib/apt/lists/*;

RUN cargo build --release

FROM debian:stretch

WORKDIR /

COPY --from=builder /usr/src/bioyino/target/release/bioyino /usr/bin/bioyino
COPY --from=builder /usr/src/bioyino/config.toml /etc/bioyino/bioyino.toml

CMD ["bioyino"]
