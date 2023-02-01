FROM rustlang/rust:nightly as builder
WORKDIR /build
COPY . .
RUN cargo build --workspace --release 2>&1
RUN cargo test 2>&1

FROM debian:stretch-slim
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates libssl1.1 && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /build/target/release/bandsocks /usr/bin/bandsocks
RUN adduser bandsocks --disabled-login </dev/null >/dev/null 2>/dev/null
USER bandsocks:bandsocks
WORKDIR /home/bandsocks
ENTRYPOINT ["/usr/bin/bandsocks"]

