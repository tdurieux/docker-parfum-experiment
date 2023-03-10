FROM --platform=${BUILDPLATFORM:-linux/amd64} tonistiigi/xx:golang AS xgo
FROM --platform=${BUILDPLATFORM:-linux/amd64} golang:1.13-alpine AS builder

ENV CGO_ENABLED 0
ENV GO111MODULE on
ENV GOPROXY https://goproxy.io
COPY --from=xgo / /

ARG TARGETPLATFORM
RUN go env

RUN apk --update --no-cache add \
    build-base \
    gcc \
    git \
  && rm -rf /tmp/* /var/cache/apk/*

WORKDIR /app

ENV DIUN_VERSION="v3.0.0"

RUN git clone --branch ${DIUN_VERSION} https://github.com/crazy-max/diun .
RUN go mod download
RUN go build -ldflags "-w -s -X 'main.version=test'" -v -o diun cmd/main.go

FROM --platform=${TARGETPLATFORM:-linux/amd64} alpine:latest

COPY --from=builder /app/diun /usr/local/bin/diun
COPY --from=builder /usr/local/go/lib/time/zoneinfo.zip /usr/local/go/lib/time/zoneinfo.zip
RUN diun --version