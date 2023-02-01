FROM golang:alpine

RUN apk update && apk add --no-cache git
RUN go get github.com/urfave/cli
RUN go get github.com/Sirupsen/logrus

RUN mkdir -p /go/src/etcdwrapper
WORKDIR /go/src/etcdwrapper
ADD wrapper.go .

RUN go build
