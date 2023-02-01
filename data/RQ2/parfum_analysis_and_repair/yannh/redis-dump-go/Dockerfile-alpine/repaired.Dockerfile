FROM alpine:3.15
MAINTAINER Yann HAMON <yann@mandragor.org>
RUN apk add --no-cache ca-certificates
COPY redis-dump-go /
ENTRYPOINT ["/redis-dump-go"]