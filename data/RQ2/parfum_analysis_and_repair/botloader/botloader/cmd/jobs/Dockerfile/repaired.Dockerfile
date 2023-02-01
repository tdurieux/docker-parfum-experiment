# You need to build the base image first and tag it as botloader-base
FROM botloader-base as builder
RUN cargo build --release --bin jobs

#run
FROM debian:bullseye AS runtime
WORKDIR /app
COPY --from=builder /app/target/release/jobs /usr/local/bin/botloader-jobs

RUN apt-get update && apt-get install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/usr/local/bin/botloader-jobs"]