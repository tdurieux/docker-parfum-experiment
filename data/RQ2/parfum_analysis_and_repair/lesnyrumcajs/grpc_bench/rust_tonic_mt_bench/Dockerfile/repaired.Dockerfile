FROM rust:1.59

WORKDIR /app
COPY rust_tonic_mt_bench /app
COPY proto /app/proto

RUN apt-get update && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN rustup component add rustfmt
RUN cargo build --release --locked

ENTRYPOINT ["/app/target/release/helloworld-server"]
