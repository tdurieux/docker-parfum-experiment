FROM alpine:latest
MAINTAINER Ahmet Alp Balkan

RUN apk --update upgrade && \
    apk add --no-cache ca-certificates tzdata && \
    update-ca-certificates tzdata && \
    rm -rf /var/cache/apk/*

COPY ./bin /bin
