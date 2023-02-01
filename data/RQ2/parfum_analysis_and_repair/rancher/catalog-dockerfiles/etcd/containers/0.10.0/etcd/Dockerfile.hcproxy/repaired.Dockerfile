FROM golang:alpine

RUN apk update && apk add --no-cache git
RUN go get github.com/urfave/cli

RUN mkdir -p /go/src/etcdhc
WORKDIR /go/src/etcdhc
ADD hcproxy.go .

RUN go build
