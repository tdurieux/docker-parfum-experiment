FROM ekidd/rust-musl-builder:1.57.0 as builder
USER root
RUN apt update && apt upgrade -y && apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN rustup component add rustfmt
RUN mkdir /rustica
COPY proto /tmp/proto
COPY rustica /tmp/rustica
WORKDIR /tmp/rustica

RUN cargo build --target=x86_64-unknown-linux-musl --features="influx" --release

FROM alpine:3.6 as alpine
RUN apk add -U --no-cache ca-certificates

from scratch as runtime
COPY --from=alpine /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /tmp/rustica/target/x86_64-unknown-linux-musl/release/rustica /rustica
USER 1000
ENTRYPOINT [ "/rustica" ]
