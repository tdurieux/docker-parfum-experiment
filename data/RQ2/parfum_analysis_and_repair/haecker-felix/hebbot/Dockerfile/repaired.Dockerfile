# Build stage

FROM rust:1.57-buster as cargo-build
RUN apt-get update && apt-get -y --no-install-recommends install libolm-dev cmake && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/hebbot
COPY Cargo.lock .
COPY Cargo.toml .
COPY ./src src

RUN cargo install --locked --path .


# Final stage

FROM debian:stable-slim
RUN apt-get update && apt-get -y --no-install-recommends install libssl-dev ca-certificates wget curl git && rm -rf /var/lib/apt/lists/*;

COPY --from=cargo-build /usr/local/cargo/bin/hebbot /bin

CMD ["sh", "-c", "RUST_LOG=hebbot=debug hebbot"]
