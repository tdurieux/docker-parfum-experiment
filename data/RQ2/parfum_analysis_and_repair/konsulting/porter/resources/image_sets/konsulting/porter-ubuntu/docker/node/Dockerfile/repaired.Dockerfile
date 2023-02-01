#VERSION: 1.3.0
FROM alpine:3.13

ARG uid=1000

RUN apk add --update --no-cache \
    # for compilation