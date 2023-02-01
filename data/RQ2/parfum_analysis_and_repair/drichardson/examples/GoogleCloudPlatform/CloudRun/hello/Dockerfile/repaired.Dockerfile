# Build using a multi-stage build
# https://docs.docker.com/develop/develop-images/multistage-build/

FROM golang:1.14 AS builder
COPY src /build
WORKDIR /build
RUN go build

# Just for fun, build final image from scratch. Determined /helloworld binary dependencies by
# running: ldd helloworld