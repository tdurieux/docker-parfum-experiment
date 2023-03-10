FROM golang:1.18-alpine

EXPOSE 3000

ENV GOPROXY=https://proxy.golang.org

RUN apk add --no-cache --upgrade apk-tools \
    && apk add --no-cache bash curl openssl git build-base nodejs npm sqlite sqlite-dev mysql-client vim postgresql libpq postgresql-contrib libc6-compat

# Installing linter
RUN curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh \
    | sh -s -- -b $(go env GOPATH)/bin v1.24.0

# Installing Yarn
RUN npm i -g --no-progress yarn \
    && yarn config set yarn-offline-mirror /npm-packages-offline-cache \
    && yarn config set yarn-offline-mirror-pruning true && npm cache clean --force; && yarn cache clean;

# Installing buffalo binary
WORKDIR /cli
ADD . .
RUN go install ./cmd/buffalo

WORKDIR /
RUN go install github.com/gobuffalo/buffalo-pop/v3@latest

RUN mkdir /src
WORKDIR /src