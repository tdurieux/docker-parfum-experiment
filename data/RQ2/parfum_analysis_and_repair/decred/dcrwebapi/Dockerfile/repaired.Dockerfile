# build
FROM golang:1.18-alpine AS builder

WORKDIR $GOPATH/src/github.com/decred/dcrwebapi
COPY . .

# -buildvcs=false so we don't need to install git in this container. 
RUN go build -buildvcs=false -o /go/bin/dcrwebapi

# serve