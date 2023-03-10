# build stage
FROM golang:alpine AS build-env

ARG APP_VERSION=""
ARG BUILD_TIME=""

ADD . /project

RUN set -e \
    && apk add --no-cache --update \
        git \
        bash \
    && set -x \
    && adduser -D -g '' openapi \
    && go version \
    && cd /project \
    && go mod download \
    && cd /project/cmd/openapi-mock \
    && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-w -s -X main.version=${APP_VERSION} -X main.buildTime=${BUILD_TIME}" -o openapi-mock \
    && ls -la | grep "openapi-mock"

# final stage