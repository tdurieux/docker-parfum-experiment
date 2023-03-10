# Build status-go in a Go builder container
FROM golang:1.13-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ARG build_tags
ARG build_flags

RUN mkdir -p /go/src/github.com/status-im/status-go
WORKDIR /go/src/github.com/status-im/status-go
ADD . .
RUN make statusgo BUILD_TAGS="$build_tags" BUILD_FLAGS="$build_flags"

# Copy the binary to the second image
FROM alpine:latest

LABEL maintainer="support@status.im"
LABEL source="https://github.com/status-im/status-go"
LABEL description="status-go is an underlying part of Status - a browser, messenger, and gateway to a decentralized world."

RUN apk add --no-cache ca-certificates bash
RUN mkdir -p /static/keys

COPY --from=builder /go/src/github.com/status-im/status-go/build/bin/statusd /usr/local/bin/
COPY --from=builder /go/src/github.com/status-im/status-go/static/keys/* /static/keys/

# 30304 is used for Discovery v5