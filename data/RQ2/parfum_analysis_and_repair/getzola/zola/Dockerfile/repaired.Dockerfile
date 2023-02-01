FROM rust:slim AS builder

RUN apt-get update -y && \
  apt-get install --no-install-recommends -y make g++ libssl-dev && \
  rustup target add x86_64-unknown-linux-gnu && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
COPY . .

RUN cargo build --release --target x86_64-unknown-linux-gnu


FROM gcr.io/distroless/cc
COPY --from=builder /app/target/x86_64-unknown-linux-gnu/release/zola /bin/zola
ENTRYPOINT [ "/bin/zola" ]
