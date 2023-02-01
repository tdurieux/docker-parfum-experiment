# Build turing-api binary
FROM golang:1.18-alpine as api-builder
ARG API_BIN_NAME=turing-api

ENV GO111MODULE=on \
    GOOS=linux \
    GOARCH=amd64

ENV PROJECT_ROOT=github.com/gojek/turing/api/turing

WORKDIR /app
COPY . .

# Build Turing binary
RUN go build \
    -mod=vendor \
    -o ./bin/${API_BIN_NAME} \
    -v ${PROJECT_ROOT}/cmd

# Clean image with turing-api binary