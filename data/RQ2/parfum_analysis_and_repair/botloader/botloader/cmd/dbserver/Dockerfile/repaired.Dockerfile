# You need to build the base image first and tag it as botloader-base
FROM botloader-base as builder
RUN cargo build --release --bin dbserver

#run
FROM debian:bullseye AS runtime
WORKDIR /app
COPY --from=builder /app/target/release/dbserver /usr/local/bin/botloader-dbserver

RUN apt-get update && apt-get install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;

ENV BL_DB_API_HTTP_LISTEN_ADDR="0.0.0.0:7900"
EXPOSE 7900

# metrics
EXPOSE 7804

ENTRYPOINT ["/usr/local/bin/botloader-dbserver"]