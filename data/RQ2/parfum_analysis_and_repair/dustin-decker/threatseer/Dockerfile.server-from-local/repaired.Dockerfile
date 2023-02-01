# Build stage
ARG GO_VERSION=1.10
ARG PROJECT_PATH=/go/src/github.com/dustin-decker/threatseer
FROM golang:${GO_VERSION}-alpine AS builder
RUN apk --no-cache add ca-certificates
RUN adduser -D -u 59999 container-user
WORKDIR /go/src/github.com/dustin-decker/threatseer
COPY ./ ${PROJECT_PATH}

# Production image