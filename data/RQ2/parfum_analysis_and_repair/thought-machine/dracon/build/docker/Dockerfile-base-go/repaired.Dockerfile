FROM alpine:3.10 as alpine

RUN apk add -U --no-cache ca-certificates libc6-compat

ENTRYPOINT []

WORKDIR /