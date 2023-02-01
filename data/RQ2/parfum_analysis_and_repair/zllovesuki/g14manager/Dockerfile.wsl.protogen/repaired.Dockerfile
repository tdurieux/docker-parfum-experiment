FROM golang:1.15.6-alpine

RUN apk update
RUN apk add --no-cache protoc git protobuf-dev
RUN go get -u github.com/golang/protobuf/protoc-gen-go \
    google.golang.org/grpc/cmd/protoc-gen-go-grpc

RUN mkdir /proto

WORKDIR /proto

ENTRYPOINT ["protoc"]