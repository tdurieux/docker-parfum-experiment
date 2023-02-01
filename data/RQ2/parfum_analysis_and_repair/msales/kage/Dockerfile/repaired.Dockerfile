# Build container
FROM golang:1.11 as builder

ENV GO111MODULE=on

WORKDIR /go/src/github.com/msales/kage/
COPY ./ .

RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags "-s -X main.Version=$(git describe --tags --always)" -o kage ./cmd/kage

# Run container