# Build Stage
FROM rustlang/rust:nightly-slim AS builder
USER 0:0
WORKDIR /home/rust/src

RUN USER=root cargo new --bin autumn
WORKDIR /home/rust/src/autumn
COPY Cargo.toml Cargo.lock ./
COPY src ./src
RUN apt-get update && apt-get install --no-install-recommends -y libssl-dev pkg-config && cargo install --locked --path . && rm -rf /var/lib/apt/lists/*;

# Bundle Stage
FROM debian:buster-slim
RUN apt-get update && apt-get install --no-install-recommends -y ca-certificates ffmpeg && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /usr/local/cargo/bin/autumn ./
EXPOSE 3000
ENV AUTUMN_HOST 0.0.0.0:3000
COPY Autumn.toml ./
CMD ["./autumn"]
