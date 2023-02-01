FROM alpine:latest as certs
RUN apk add --no-cache ca-certificates

FROM scratch AS redis-dump-go
MAINTAINER Yann HAMON <yann@mandragor.org>
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY redis-dump-go /
ENTRYPOINT ["/redis-dump-go"]