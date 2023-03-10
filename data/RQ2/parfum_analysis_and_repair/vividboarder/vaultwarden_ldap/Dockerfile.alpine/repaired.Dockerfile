FROM ekidd/rust-musl-builder:1.51.0 AS builder

WORKDIR /home/rust/src

# Cache build deps
RUN USER=rust cargo init
COPY --chown=rust:rust Cargo.toml Cargo.lock ./
RUN cargo build --locked --release && \
        rm src/*.rs

COPY --chown=rust:rust ./src ./src
RUN USER=rust touch ./src/main.rs
# hadolint ignore=DL3059
RUN cargo build --release

FROM alpine:3
RUN apk --no-cache add ca-certificates=20211220-r0
COPY --from=builder \
    /home/rust/src/target/x86_64-unknown-linux-musl/release/vaultwarden_ldap \
    /usr/local/bin/

CMD ["/usr/local/bin/vaultwarden_ldap"]