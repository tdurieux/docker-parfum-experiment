FROM rustlang/rust:nightly as builder

ENV APP_HOME /usr/src/app/

RUN rustup target add x86_64-unknown-linux-musl
RUN apt-get update && apt-get install --no-install-recommends -y upx musl-tools && rm -rf /var/lib/apt/lists/*;

COPY . $APP_HOME
WORKDIR $APP_HOME
RUN make build-linux

FROM scratch
COPY --from=builder /usr/src/app/target/x86_64-unknown-linux-musl/release/dummyhttp /app/

ENTRYPOINT ["/app/dummyhttp"]
