# Builder
FROM golang:alpine AS builder
RUN apk add --no-cache git

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /build

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .

RUN go build ./cmd/aks-periscope

# Runner
FROM alpine

COPY --from=builder /build/aks-periscope /

ENTRYPOINT ["/aks-periscope"]
