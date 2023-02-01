# Build Gman in a stock Go builder container
FROM golang:1.9-alpine as builder

RUN apk add --no-cache  make gcc musl-dev linux-headers git

ADD . /go-matrix

RUN cd /go-matrix &&  chmod +x Start && chmod +x build/env.sh && make gman

# Pull Gman into a second stage deploy alpine container