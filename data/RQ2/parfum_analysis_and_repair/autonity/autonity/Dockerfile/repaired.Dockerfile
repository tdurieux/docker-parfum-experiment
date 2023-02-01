# Build Autonity in a stock Go builder container
FROM golang:1.15.5-alpine as builder

LABEL org.opencontainers.image.source https://github.com/clearmatics/autonity

RUN apk add --no-cache make gcc musl-dev linux-headers libc-dev git perl-utils

ADD . /autonity
RUN cd /autonity && make autonity

# Pull Autonity into a second stage deploy alpine container