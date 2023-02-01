# Build image
FROM golang:1.16.6 AS builder

WORKDIR /app

COPY main.go .
COPY go.mod .
COPY go.sum .
COPY internal internal
RUN go build -o mortar-server

# Runtime image