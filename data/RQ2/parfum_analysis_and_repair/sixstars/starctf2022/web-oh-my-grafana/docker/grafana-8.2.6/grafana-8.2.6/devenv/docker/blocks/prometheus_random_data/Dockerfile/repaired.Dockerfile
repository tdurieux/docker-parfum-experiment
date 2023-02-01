# This Dockerfile builds an image for a client_golang example.

# Builder image, where we build the example.
FROM golang:1.17 AS builder
# Download prometheus/client_golang/examples/random first
RUN CGO_ENABLED=0 GOOS=linux go install -tags netgo -ldflags '-w' github.com/prometheus/client_golang/examples/random@latest

# Final image.