# Multi stage build
FROM golang:1.17 as builder
ENV GO111MODULE=off
#RUN go get -d github.com/getevo/evo

WORKDIR /build
COPY . .
RUN go get -d ./...
RUN go build -o main .

# Only runtime