FROM rust:1.56-bullseye AS selene-builder
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends g++ && \
    cargo install --branch main --git https://github.com/Kampfkarren/selene selene && rm -rf /var/lib/apt/lists/*;

FROM rust:1.56-bullseye AS selene-light-builder
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends g++ && \
    cargo install --no-default-features --branch main --git https://github.com/Kampfkarren/selene selene && rm -rf /var/lib/apt/lists/*;

FROM rust:1.56-alpine3.14 AS selene-musl-builder
RUN apk add --no-cache g++ && \
    cargo install --branch main --git https://github.com/Kampfkarren/selene selene

FROM rust:1.56-alpine3.14 AS selene-light-musl-builder
RUN apk add --no-cache g++ && \
    cargo install --no-default-features --branch main --git https://github.com/Kampfkarren/selene selene

FROM bash AS selene
COPY --from=selene-builder /usr/local/cargo/bin/selene /
CMD ["/selene"]

FROM bash AS selene-light
COPY --from=selene-light-builder /usr/local/cargo/bin/selene /
CMD ["/selene"]

FROM bash AS selene-musl
COPY --from=selene-musl-builder /usr/local/cargo/bin/selene /
CMD ["/selene"]

FROM bash AS selene-light-musl
COPY --from=selene-light-musl-builder /usr/local/cargo/bin/selene /
CMD ["/selene"]
