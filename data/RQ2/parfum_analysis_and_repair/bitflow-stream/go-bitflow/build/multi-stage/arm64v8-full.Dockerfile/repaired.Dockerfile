# bitflowstream/bitflow-pipeline:latest-arm64v8
# Build from root of the repository:
# docker build -t bitflowstream/bitflow-pipeline:latest-arm64v8 -f build/multi-stage/arm64v8-full.Dockerfile .
FROM golang:1.14.1-alpine as build
RUN apk --no-cache add curl bash git mercurial gcc g++ docker musl-dev
WORKDIR /build
ENV GO111MODULE=on
ENV GOOS=linux
ENV GOARCH=arm64

# Copy go.mod first and download dependencies, to enable the Docker build cache
COPY go.mod .
RUN sed -i $(find -name go.mod) -e '\_//.*gitignore$_d' -e '\_#.*gitignore$_d'
RUN go mod download

# Copy rest of the source code and build
# Delete go.sum files and clean go.mod files form local 'replace' directives