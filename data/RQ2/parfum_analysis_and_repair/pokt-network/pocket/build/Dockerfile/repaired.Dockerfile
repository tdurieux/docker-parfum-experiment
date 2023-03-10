ARG GOLANG_IMAGE_VERSION=golang:1.17-rc-alpine3.14

FROM ${GOLANG_IMAGE_VERSION} AS builder

ENV POCKET_ROOT=/go/src/github.com/pocket-network/

WORKDIR $POCKET_ROOT

COPY . .

# Hot reloading
RUN go install github.com/cespare/reflex@latest

RUN apk add --no-cache build-base

# Debugging
RUN go install github.com/go-delve/delve/cmd/dlv@latest

# Needed to make `go install dlv` and `dlv debug` work...
RUN apk update && apk add --no-cache gcc musl-dev
RUN go get github.com/go-delve/delve/cmd/dlv@latest
