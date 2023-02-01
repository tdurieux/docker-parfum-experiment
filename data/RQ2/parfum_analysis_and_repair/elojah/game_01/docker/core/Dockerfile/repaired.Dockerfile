# builder
FROM golang:latest AS builder
WORKDIR /core
COPY . .
RUN make tidy
RUN env GOARCH=386 GOOS=linux CGO_ENABLED=0 make core

# runner