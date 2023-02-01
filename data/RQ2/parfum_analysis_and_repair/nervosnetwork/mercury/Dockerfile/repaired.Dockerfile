FROM rust:1.60 as builder

WORKDIR /build
COPY . .

RUN apt-get update
RUN apt-get install --no-install-recommends cmake clang llvm gcc -y && rm -rf /var/lib/apt/lists/*;
RUN cd /build && cargo build --release

FROM debian:bookworm-20211011-slim
WORKDIR /app

RUN apt-get update
RUN apt install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libc6-dev && rm -rf /var/lib/apt/lists/*;

COPY --from=builder /build/target/release/mercury /app/mercury
COPY --from=builder /build/free-space /app/free-space
COPY --from=builder /build/devtools /app/devtools

EXPOSE 8116

CMD mercury -c devtools/config/docker_compose_config.toml


