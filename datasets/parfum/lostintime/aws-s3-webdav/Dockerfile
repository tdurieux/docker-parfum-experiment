# Build the app
FROM rust:1.28.0 as builder

WORKDIR /app
COPY . .

RUN cargo build --release --target x86_64-unknown-linux-gnu


FROM debian:stretch-slim

# install openssl
RUN apt-get update && apt-get install -y --no-install-recommends \
		openssl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/target/x86_64-unknown-linux-gnu/release/aws_s3_webdav /usr/bin/aws_s3_webdav

EXPOSE 8080

ENTRYPOINT [ "/usr/bin/aws_s3_webdav" ]
