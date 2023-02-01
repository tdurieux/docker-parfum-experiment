FROM alpine:3.14 as certs
MAINTAINER Yann HAMON <yann@mandragor.org>
RUN apk add --no-cache ca-certificates
COPY kubeconform /
ENTRYPOINT ["/kubeconform"]
