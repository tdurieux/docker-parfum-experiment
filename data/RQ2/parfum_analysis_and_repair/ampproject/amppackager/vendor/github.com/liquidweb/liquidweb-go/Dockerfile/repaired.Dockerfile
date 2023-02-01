FROM golang:alpine

RUN apk add --no-cache -U make
RUN mkdir -p /go/src/github.com/liquidweb/liquidweb-go

WORKDIR /go/src/github.com/liquidweb/liquidweb-go

COPY . .
RUN make build
