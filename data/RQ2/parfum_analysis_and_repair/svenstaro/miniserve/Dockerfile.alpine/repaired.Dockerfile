# This Dockerfile results in an Alpine container containing the minishift executable.
# Use this in case you need additional basic tools provided by Alpine in this container.
FROM rust as builder

ENV APP_HOME /usr/src/app/

RUN rustup target add x86_64-unknown-linux-musl
RUN apt update && apt-get install --no-install-recommends -y upx musl-tools && rm -rf /var/lib/apt/lists/*;

COPY . $APP_HOME
WORKDIR $APP_HOME
RUN make build-linux

FROM alpine
RUN apk add --no-cache rsync
COPY --from=builder /usr/src/app/target/x86_64-unknown-linux-musl/release/miniserve /app/

EXPOSE 8080
ENTRYPOINT ["/app/miniserve"]
