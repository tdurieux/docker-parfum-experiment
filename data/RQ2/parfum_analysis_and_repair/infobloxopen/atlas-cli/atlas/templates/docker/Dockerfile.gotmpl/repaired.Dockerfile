# build the server binary
FROM golang:1.16.3 AS builder
LABEL stage=server-intermediate
WORKDIR /go/src/{{ .Root }}/{{ .Name }}

COPY . .
RUN go build -mod=vendor -o bin/server ./cmd/server

# copy the server binary from builder stage; run the server binary
FROM alpine:latest AS runner
WORKDIR /bin

# Go programs require libc