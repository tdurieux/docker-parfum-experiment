#
# Build phase
#
FROM golang:1.18-alpine as build

RUN apk add --no-cache \
    git \
    build-base \
    pkgconfig \
    libvirt-dev

WORKDIR /build

COPY go.mod /build
COPY go.sum /build

RUN go mod download

WORKDIR /

COPY pkg /build/pkg
COPY stats /build/stats

WORKDIR /build/stats

RUN go build -o bin/stats cmd/stats/main.go


#
# Stats
#