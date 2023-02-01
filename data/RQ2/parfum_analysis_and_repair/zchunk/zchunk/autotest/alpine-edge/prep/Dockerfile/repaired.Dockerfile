FROM alpine:edge

RUN apk add --no-cache meson gcc musl-dev zstd-dev curl-dev openssl1.1-compat-dev argp-standalone
