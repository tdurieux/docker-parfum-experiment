# Build go
FROM golang:1.18-alpine AS builder
WORKDIR /app
COPY . .
ENV CGO_ENABLED=0
RUN go mod download && \
    go env -w GOFLAGS=-buildvcs=false && \
    go build -v -o au -trimpath -ldflags "-s -w -buildid=" ./cmd/Air-Universe

# Release
FROM alpine
# 安装必要的工具包