#This image is a microservice in golang for the Degree chaincode
FROM golang:1.13.8-alpine AS build

COPY ./ /go/src/github.com/abstore
WORKDIR /go/src/github.com/abstore

# Build application
RUN  GOPROXY="https://goproxy.cn" GO111MODULE=on   go build -mod vendor -o chaincode -v .

# Production ready image
# Pass the binary to the prod image