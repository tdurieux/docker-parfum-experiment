# build vFlow in the first stage
FROM golang:1.15.3 as builder
WORKDIR /go/src/

RUN mkdir -p github.com/EdgeCast/vflow
ADD . github.com/EdgeCast/vflow
WORKDIR /go/src/github.com/EdgeCast/vflow
RUN make build

# run vFlow within alpine in the second stage