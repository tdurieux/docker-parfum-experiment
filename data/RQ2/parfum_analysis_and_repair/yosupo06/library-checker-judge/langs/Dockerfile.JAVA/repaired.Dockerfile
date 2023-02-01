FROM ekidd/rust-musl-builder:latest as init-builder
COPY --chown=rust:rust init .
RUN cargo build --release

FROM openjdk:17
COPY --from=init-builder /home/rust/src/target/x86_64-unknown-linux-musl/release/library-checker-init /usr/bin