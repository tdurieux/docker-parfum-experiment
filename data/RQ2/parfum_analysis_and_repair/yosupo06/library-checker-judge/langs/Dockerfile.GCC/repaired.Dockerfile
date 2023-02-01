FROM ekidd/rust-musl-builder:latest as init-builder
COPY --chown=rust:rust init .
RUN cargo build --release

FROM ubuntu as builder
RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
WORKDIR /workdir
RUN git clone https://github.com/atcoder/ac-library/ -b v1.4

FROM gcc:12.1
COPY --from=builder /workdir/ac-library/atcoder /opt/ac-library/atcoder
COPY init /usr/bin

COPY --from=init-builder /home/rust/src/target/x86_64-unknown-linux-musl/release/library-checker-init /usr/bin
