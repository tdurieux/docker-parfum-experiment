# Dockerfile for building coordinated into a container.
# setup.sh will prepare prerequisites in the current directory.

# Build image
FROM golang:1.12 AS builder

# Outside GOPATH to use go modules
WORKDIR /src

# Fetch dependencies first, less susceptible to change on every build
COPY ./go.mod ./go.sum ./
RUN go mod download

# Copy in code
COPY ./ ./

RUN CGO_ENABLED=0 go build -v -o /coordinated ./cmd/coordinated

# Application image
FROM scratch

ARG VERSION
ARG BUILD
ARG NOW

COPY --from=builder /coordinated /coordinated

# CBOR-RPC interface
EXPOSE 5932
# HTTP REST interface