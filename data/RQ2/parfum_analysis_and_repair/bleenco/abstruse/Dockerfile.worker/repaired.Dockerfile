# stage 1 build
FROM golang:1.16-alpine as build

ARG GIT_COMMIT=""
ENV GIT_COMMIT=$GIT_COMMIT

WORKDIR /app

RUN apk --no-cache add git make protobuf protobuf-dev ca-certificates alpine-sdk

COPY . /app/

RUN go get github.com/jkuri/statik github.com/golang/protobuf/protoc-gen-go github.com/google/wire/...

RUN make protoc && make wire && make worker

# stage 2 image