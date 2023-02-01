FROM golang:1.15-alpine
LABEL maintainer="The Prometheus Authors <prometheus-developers@googlegroups.com>"

RUN apk add --no-cache git make

COPY infra /bin/infra

ENTRYPOINT ["/bin/infra"]
