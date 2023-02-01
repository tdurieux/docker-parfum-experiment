# Base image for building purposes
FROM docker.io/golang:1.15.5-alpine3.12 as builder

RUN apk --no-cache add alsa-lib-dev git alpine-sdk

WORKDIR /jellycli

ARG JELLYCLI_BRANCH=master

# use caching layers as needed

RUN git clone -b ${JELLYCLI_BRANCH} --single-branch --depth 1 https://github.com/tryffel/jellycli ./

RUN go mod download

RUN go build . && ./jellycli --help


# Alpine runtime