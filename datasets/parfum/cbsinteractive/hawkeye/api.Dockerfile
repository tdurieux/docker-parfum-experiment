#
# Build the executable artifacts to include in a final image.
#
FROM rust:1.57-slim-buster as builder

RUN apt-get update -qq
RUN apt-get install -yq \
    pkg-config \
    libssl-dev
COPY Cargo.toml /Cargo.toml
COPY Cargo.lock /Cargo.lock
COPY hawkeye-api /hawkeye-api
COPY hawkeye-core /hawkeye-core
COPY hawkeye-worker /hawkeye-worker
COPY resources /resources
RUN cargo build --release --package hawkeye-api

#
# Build the final image containing the built executables.
#
FROM debian:buster-slim as app

# Make RUST_LOG configurable at buld time.
# This may be overridden with `-e RUST_LOG=debug` at `docker run` time.
ARG RUST_LOG=info
ENV RUST_LOG ${RUST_LOG}

RUN apt-get update -qq \
    && apt-get install -y \
        libssl-dev

COPY --from=builder /target/release/hawkeye-api .
ENTRYPOINT ["/hawkeye-api"]
