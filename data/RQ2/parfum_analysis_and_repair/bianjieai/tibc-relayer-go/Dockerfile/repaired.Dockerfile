# Build image: docker build -t relayers/fabric .
FROM golang:1.15-alpine3.12 as builder

# Set up dependencies
ENV PACKAGES make git libc-dev bash gcc
WORKDIR $GOPATH/src
COPY . .
# Install minimum necessary dependencies, build binary