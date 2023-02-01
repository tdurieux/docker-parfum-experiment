FROM rust:1.59.0 AS builder
WORKDIR /fishnet
COPY . .
RUN (git submodule update --init --recursive || true) \
    && ( \
        if [ -e sde-external-9.0.0-2021-11-07-lin/sde64 ]; then \
            env SDE_PATH="$PWD/sde-external-9.0.0-2021-11-07-lin/sde64" cargo build --release -vv; \
        else \
            cargo build --release -vv; \
        fi \
    )

# Not using alpine due to https://andygrove.io/2020/05/why-musl-extremely-slow/
FROM debian:11-slim
COPY --from=builder /fishnet/target/release/fishnet /fishnet
COPY docker-entrypoint.sh /docker-entrypoint.sh
CMD ["/docker-entrypoint.sh"]
