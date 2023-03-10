FROM golang:latest

WORKDIR /go/src
COPY httpserver.go .

RUN go build -o myhttpserver ./httpserver.go