FROM alpine:3.14.1 as base

RUN apk --update --no-cache add \
  rsync \
  protoc=3.15.7-r1 \
  protobuf=3.15.7-r1 \
  protobuf-dev=3.15.7-r1 \
  nodejs \
  alpine-sdk \
  bash

FROM golang:1.18.3 as builder

ARG CGO_ENABLED=0
ARG GOOS=linux
ARG GOARCH=amd64
ARG GO111MODULE=on

COPY . /src
RUN cd /src && go build -mod=vendor -o /tmp/protoc-gen-go ./vendor/google.golang.org/protobuf/cmd/protoc-gen-go
#RUN cd /src && go build -mod=vendor -o /tmp/protoc-gen-go-grpc ./vendor/google.golang.org/grpc/cmd/protoc-gen-go-grpc
RUN cd /src && go build -mod=vendor -o /tmp/protoc-gen-twirp ./vendor/github.com/twitchtv/twirp/protoc-gen-twirp
RUN cd /src && go build -mod=vendor -o /tmp/protoc-gen-doc ./vendor/github.com/pseudomuto/protoc-gen-doc/cmd/protoc-gen-doc
RUN cd /src && go build -mod=vendor -o /tmp/protoc-gen-openapiv2 ./vendor/github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2
RUN cd /src && go build -mod=vendor -o /tmp/protoc-gen-gotag ./vendor/github.com/srikrsna/protoc-gen-gotag

# This lib doesn't support Twirp v7
RUN cd /src && go build -mod=vendor -o /tmp/protoc-gen-twirp_js ./vendor/github.com/thechriswalker/protoc-gen-twirp_js


FROM base

COPY vendor/github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2 /tmp/protoc-gen-openapiv2
RUN rsync -av --include="*/" --include "*.proto" --exclude="*" /tmp/protoc-gen-openapiv2 /usr/include/
RUN rm -rf /tmp/protoc-gen-openapiv2

COPY --from=builder /tmp/protoc-gen-* /usr/bin/

#ADD https://github.com/grpc/grpc-web/archive/refs/tags/1.2.1.tar.gz /tmp/
#RUN cd /tmp && tar xzf /tmp/1.2.1.tar.gz && \
#    cd /tmp/grpc-web-1.2.1 && \
#    make install-plugin