FROM rust:1.59

RUN apt update && apt install --no-install-recommends -y protobuf-compiler cmake && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY rust_grpcio_bench /app
COPY proto /app/src/proto

RUN cargo build --release --locked

ENTRYPOINT ["/app/target/release/helloworld-server"]
