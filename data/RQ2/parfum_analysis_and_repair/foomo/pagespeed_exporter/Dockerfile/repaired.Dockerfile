# -----------------------------------------------------------------------------
# Builder Base
# -----------------------------------------------------------------------------
FROM golang:alpine as base
MAINTAINER  Stefan Martinov <stefan.martinov@bestbytes.com>

RUN apk add --no-cache git \
  && rm -rf /var/cache/apk/*

WORKDIR /app

COPY ./go.mod ./go.sum ./

RUN go mod download

COPY . ./

##############################
###### STAGE: BUILD     ######
##############################
FROM base as builder
MAINTAINER  Stefan Martinov <stefan.martinov@bestbytes.com>

RUN GOARCH=amd64 GOOS=linux CGO_ENABLED=0 \
    go build -ldflags "-X main.Version=`git rev-parse --short HEAD`" -o /pagespeed_exporter pagespeed_exporter.go


##############################
###### STAGE: PACKAGE   ######
##############################