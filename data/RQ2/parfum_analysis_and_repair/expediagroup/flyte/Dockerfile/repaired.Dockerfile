# Build image
FROM golang:1.15.8 AS build-env

WORKDIR /app
ENV GO111MODULE=on
ENV CGO_ENABLED=0
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN go test ./...
RUN go build

# Run image