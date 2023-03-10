############################################################
# Dockerfile to build kubicorn container images
# Based on golang tip
############################################################

FROM golang:latest

# Create the default data directory
RUN go get github.com/kubicorn/kubicorn/...

WORKDIR /go/src/github.com/kubicorn/kubicorn/

# Runs appropriate make command based on environment
RUN  CGO_ENABLED=0 GOOS=linux  make docker-build-linux-amd64
#RUN GOOS=darwin make build-darwin-amd64
#RUN GOOS=windows make build-windows-amd64
#RUN GOOS=freebsd make build-freebsd-amd64 

# Multi-stage build docker image
FROM alpine:latest

# File Author / Maintainer