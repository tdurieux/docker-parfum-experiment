FROM golang:1.10

RUN apt-get update \
 && apt-get install -y zip \
 && apt-get install -y sudo libltdl-dev

COPY . /go/src/github.com/Azure/azure-container-networking

WORKDIR /go/src/github.com/Azure/azure-container-networking
