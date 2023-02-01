# Build
FROM golang:1.12-alpine AS builder
WORKDIR /app
# https://github.com/docker-library/golang/issues/209
RUN apk add --no-cache git
COPY go.mod go.sum ./
COPY services/common services/common
COPY services/tweets services/tweets
RUN go build -ldflags="-s -w" -o app services/tweets/cmd/main.go

# App