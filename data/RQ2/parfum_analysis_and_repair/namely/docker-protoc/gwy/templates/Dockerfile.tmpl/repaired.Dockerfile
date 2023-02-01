# Template for grpc-gateway 

ARG alpine_version=3.14
ARG go_version=1.17
FROM golang:$go_version-alpine$alpine_version AS build

RUN apk add --update --no-cache git
WORKDIR /app

# Copy all of the staged files (protos plus go source)
COPY . /app/

RUN go mod tidy

# Build the gateway