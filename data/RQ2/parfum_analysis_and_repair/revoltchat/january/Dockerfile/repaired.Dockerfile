# Build Stage
FROM rustlang/rust:nightly-slim AS builder
USER 0:0
WORKDIR /home/rust/src

RUN USER=root cargo new --bin january
WORKDIR /home/rust/src/january
COPY Cargo.toml Cargo.lock ./
COPY src ./src
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev pkg-config && cargo install --locked --path . && rm -rf /var/lib/apt/lists/*;

# Bundle Stage
FROM debian:buster-slim
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates ffmpeg && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /usr/local/cargo/bin/january ./
EXPOSE 7000
ENV JANUARY_HOST 0.0.0.0:7000
CMD ["./january"]
