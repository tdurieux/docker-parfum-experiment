# This is a multi-stage build.

# build stage
FROM golang:1.18 AS builder
WORKDIR /go/src/hargo
COPY . /go/src/hargo

ARG VERSION
ARG HASH
ARG DATE

ENV GOPROXY=direct
RUN go mod download

ENV CGO_ENABLED=0
ENV GOOS=linux

RUN go build -ldflags "-s -w -X main.Version=$VERSION -X main.CommitHash=$HASH -X 'main.CompileDate=$DATE'" -o hargo ./cmd/hargo

# final stage
FROM scratch

WORKDIR /
ENV PATH=/

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/src/hargo/hargo /

# Metadata params
ARG VERSION
ARG BUILD_DATE
ARG VCS_URL
ARG VCS_REF
ARG NAME
ARG VENDOR

# Metadata