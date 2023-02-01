# This Dockerfile results in a super small container containing only the miniserve binary and nothing else.
# Use this in case you don't need any additional tools in the container.
FROM rust as builder

ENV APP_HOME /usr/src/app/

RUN rustup target add x86_64-unknown-linux-musl
RUN apt update && apt-get install --no-install-recommends -y upx musl-tools && rm -rf /var/lib/apt/lists/*;

COPY . $APP_HOME
WORKDIR $APP_HOME
RUN make build-linux

FROM scratch
COPY --from=builder /usr/src/app/target/x86_64-unknown-linux-musl/release/miniserve /app/

EXPOSE 8080
ENTRYPOINT ["/app/miniserve"]
