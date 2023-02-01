FROM rust:alpine AS builder
RUN apk add --no-cache --update gcc g++ build-base alpine-sdk sqlite-dev openssl-dev postgresql-dev
WORKDIR /app
COPY . /app
RUN cargo build --release --features postgres

FROM alpine AS chartered-git
RUN apk add --no-cache --update postgresql-dev && \
    ln -s /lib/ld-musl-$(uname -m).so.1 /lib/ld-linux-$(uname -m).so.1
WORKDIR /app
COPY --from=builder /app/target/release/chartered-git /app/chartered-git
ENTRYPOINT ["/app/chartered-git"]

FROM alpine AS chartered-web
RUN apk add --no-cache --update postgresql-dev && \
    ln -s /lib/ld-musl-$(uname -m).so.1 /lib/ld-linux-$(uname -m).so.1
WORKDIR /app
COPY --from=builder /app/target/release/chartered-web /app/chartered-web
ENTRYPOINT ["/app/chartered-web"]
