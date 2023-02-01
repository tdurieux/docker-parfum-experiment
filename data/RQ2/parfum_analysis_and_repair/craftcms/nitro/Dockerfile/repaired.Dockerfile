# grab the caddy binary
FROM caddy:2.3.0-alpine AS caddy

# build the api
FROM golang:1.17-alpine AS builder
ARG NITRO_VERSION
ENV NITRO_VERSION=${NITRO_VERSION}
WORKDIR /go/src/github.com/craftcms/nitro
COPY . .
RUN GOOS=linux go build -ldflags="-s -w -X 'github.com/craftcms/nitro/pkg/api/api.Version=${NITRO_VERSION}'" -o nitrod ./cmd/nitrod

# build the final image
FROM alpine:3

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

# label the container