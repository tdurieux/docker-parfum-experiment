FROM ubuntu:12.04
FROM golang:1.6

ADD . /go/src/github.com/aws/aws-sdk-go

WORKDIR /go/src/github.com/aws/aws-sdk-go
CMD ["make", "unit"]