#
# Build phase
#
FROM golang:1.16-alpine as build

RUN apk add --no-cache \
    git

WORKDIR /build

COPY go.mod /build
COPY go.sum /build

RUN go mod download

WORKDIR /

COPY pkg /build/pkg
COPY authentication /build/authentication

WORKDIR /build/authentication

RUN CGO_ENABLED=0 go build -o bin/authentication cmd/authentication/main.go


#
# Authentication
#