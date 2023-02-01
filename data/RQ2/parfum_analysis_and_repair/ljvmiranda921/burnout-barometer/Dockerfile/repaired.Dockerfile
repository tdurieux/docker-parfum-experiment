# Build executable binary
FROM golang:1.13.0-alpine AS builder

ENV GO111MODULE=on

WORKDIR /app

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY . .
RUN go build -o ./build/barometer .


# Build minimal image with entrypoint
FROM alpine

WORKDIR /app

COPY --from=builder /app/build/barometer . 
COPY --from=builder /app/docker-entrypoint.sh .

# Setup environment variables