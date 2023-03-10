##
# BUILD CONTAINER
##

FROM alpine:3.15.0 as certs

RUN \
  apk add --no-cache ca-certificates

##
# RELEASE CONTAINER
##

FROM busybox:1.35.0-glibc

WORKDIR /

COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY tfcw /usr/local/bin/

# Run as nobody user