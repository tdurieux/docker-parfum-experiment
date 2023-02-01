# base stage
FROM golang:1.18.2-alpine3.14 AS base

ARG GOPROXY

RUN apk add --update git ca-certificates build-base openssh-client

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub

COPY ./go.mod ./

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub/ssh

COPY ./ssh/go.mod ./ssh/go.sum ./

RUN go mod download

# builder stage
FROM base AS builder

ARG GOPROXY

COPY ./pkg $GOPATH/src/github.com/shellhub-io/shellhub/pkg
COPY ./ssh .

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub

RUN go mod download

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub/ssh

RUN go build -tags internal_api

# development stage
FROM base AS development

ARG GOPROXY
ENV GOPROXY ${GOPROXY}

RUN apk add --update openssl
RUN go install github.com/markbates/refresh@v1.11.1 && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@v1.42.1 && \
    go install github.com/vektra/mockery/v2/...@v2.10.4

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub

RUN go mod download

COPY ./ssh/entrypoint-dev.sh /entrypoint.sh

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub/ssh

ENTRYPOINT ["/entrypoint.sh"]

# production stage
FROM alpine:3.16.0 AS production

RUN apk add --update openssh-client

COPY --from=builder /go/src/github.com/shellhub-io/shellhub/ssh/ssh /ssh

ENTRYPOINT /ssh
