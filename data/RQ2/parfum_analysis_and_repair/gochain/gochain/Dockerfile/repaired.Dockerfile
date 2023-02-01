# Build GoChain in a stock Go builder container
FROM golang:1.18-alpine as builder

RUN apk --no-cache add build-base git mercurial gcc linux-headers
ENV D=/gochain
WORKDIR $D
# cache dependencies
ADD go.mod $D
ADD go.sum $D
RUN go mod download
# build
ADD . $D
RUN cd $D && make all && mkdir -p /tmp/gochain && cp $D/bin/* /tmp/gochain/

# Pull all binaries into a second stage deploy alpine container