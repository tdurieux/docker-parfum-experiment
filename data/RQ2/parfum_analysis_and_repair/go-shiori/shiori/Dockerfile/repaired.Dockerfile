# build stage
FROM ghcr.io/ghcri/golang:1.17-alpine3.15 AS builder
WORKDIR /src
COPY . .
RUN go build -ldflags '-s -w'

# server image