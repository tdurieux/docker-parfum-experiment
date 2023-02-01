FROM golang:1.16-alpine

ARG PROTOC_VERSION="3.12.2"
RUN apk add --no-cache g++
# add make
RUN apk add --no-cache make
# add curl
RUN apk add --no-cache curl
# install protobuf
RUN apk add --no-cache "protoc"
# sanity check to verify its correctly installed
RUN protoc --version
# install
RUN GO111MODULE=on go get google.golang.org/protobuf/cmd/protoc-gen-go google.golang.org/grpc/cmd/protoc-gen-go-grpc

WORKDIR /build
COPY . ./

RUN go build -o protoc-gen-go-pulsar ./cmd/protoc-gen-go-pulsar

WORKDIR /codegen

RUN mv /build/protoc-gen-go-pulsar /usr/bin/protoc-gen-go-pulsar
