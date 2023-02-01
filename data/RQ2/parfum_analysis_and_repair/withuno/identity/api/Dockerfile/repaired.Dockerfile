FROM rustlang/rust:nightly as builder
WORKDIR /app
COPY . .
RUN cargo +nightly test --release
RUN cargo +nightly install --path api --root . --features s3

FROM debian:buster-slim
RUN apt update && apt install --no-install-recommends -y libcurl4 && rm -rf /var/lib/apt/lists/*;
WORKDIR /root
EXPOSE 8080
COPY --from=builder /app/bin/ /usr/local/bin/
CMD [ "api" ]

