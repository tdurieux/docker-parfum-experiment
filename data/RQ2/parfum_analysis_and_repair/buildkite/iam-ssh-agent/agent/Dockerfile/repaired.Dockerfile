FROM rust:1.41 AS BUILD

RUN rustup target add x86_64-unknown-linux-musl

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
      musl-tools && rm -rf /var/lib/apt/lists/*;

COPY ["src/", "/workspace/src"]
COPY ["Cargo.toml", "Cargo.lock", "/workspace/"]
WORKDIR /workspace
RUN cargo build --release --target x86_64-unknown-linux-musl

FROM alpine:3.11

RUN apk add --no-cache ca-certificates

COPY --from=BUILD /workspace/target/x86_64-unknown-linux-musl/release/iam-ssh-agent bin/