FROM golang:1.18 AS builder

ARG VERSION=latest
ARG LFLAGS

COPY . /go/src/github.com/appvia/terraform-controller

ENV \
  CGO_ENABLED=0 \
  VERSION=$VERSION

RUN cd /go/src/github.com/appvia/terraform-controller && make controller

FROM alpine:3.15.4

RUN apk add --no-cache ca-certificates

COPY --from=builder /go/src/github.com/appvia/terraform-controller/bin/controller /bin/controller

USER 65534

ENTRYPOINT ["/bin/controller"]
