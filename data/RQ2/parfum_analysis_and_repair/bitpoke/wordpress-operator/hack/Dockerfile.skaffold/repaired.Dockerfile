# Build the dashboard binary
FROM golang:1.16 as builder

ARG BUILD_DATE=""
ARG GIT_COMMIT="unavailable"
ARG GIT_TREE_STATE="clean"

ENV BUILD_DATE=$BUILD_DATE
ENV GIT_COMMIT=$GIT_COMMIT
ENV GIT_TREE_STATE=$GIT_TREE_STATE

# Copy in the go src
WORKDIR /app
COPY pkg/    pkg/
COPY cmd/    cmd/
COPY go.mod  go.mod
COPY go.sum  go.sum

# Build
RUN GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -a -o wp-operator ./cmd/wordpress-operator/main.go

# Copy the operator binary into a thin image