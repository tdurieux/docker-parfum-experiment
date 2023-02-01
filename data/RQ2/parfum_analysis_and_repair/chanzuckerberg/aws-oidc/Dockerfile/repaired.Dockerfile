# First stage: build the executable
FROM golang:1.17 AS builder

# Enable Go modules
ENV GO111MODULE=on CGO_ENABLED=0 GOOS=linux

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy the source from the current directory to the Working Directory inside the container
COPY cmd cmd
COPY go.mod go.sum main.go ./
COPY pkg pkg

# Build the Go app
RUN go build -o aws-oidc .

# Final stage: the running container
FROM alpine:latest AS final

# Install SSL root certificates