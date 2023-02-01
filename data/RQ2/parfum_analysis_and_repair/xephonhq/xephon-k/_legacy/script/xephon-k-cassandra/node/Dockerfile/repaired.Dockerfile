#FROM alpine:3.5
FROM ubuntu:16.04

MAINTAINER at15 at15@dongyue.io

# Thanks to @zbintliff in https://github.com/kairosdb/kairosdb/issues/288
#RUN apk upgrade libssl1.0 --update-cache && \
#    apk add curl ca-certificates bash

# KairosDB must start after Cassandra is running and thrift protocol is enabled