FROM alpine:3.14.0

RUN apk add --no-cache alpine-sdk coreutils

COPY ash_test /project/test