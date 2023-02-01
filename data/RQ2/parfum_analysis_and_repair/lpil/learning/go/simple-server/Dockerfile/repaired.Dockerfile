# Build
FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git
RUN adduser -D -g '' appuser
WORKDIR /tmp/simple-server
COPY . .
RUN go mod download
RUN GOOS=linux GOARCH=amd64 go build -ldflags="-w -s" -o /simple-server

# Release