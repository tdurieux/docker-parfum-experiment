FROM rust:1.54 as builder
WORKDIR /usr/src/myapp
RUN rustup component add rustfmt 
COPY . .
RUN cargo install --path .

FROM debian:buster-slim
COPY ecc_config.json .
COPY raft_config.json .
COPY --from=builder /usr/local/cargo/bin/distributed_cache /usr/local/bin/distributed_cache
ENTRYPOINT ["distributed_cache"]

