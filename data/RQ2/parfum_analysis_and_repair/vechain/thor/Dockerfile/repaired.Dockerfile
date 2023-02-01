# Build thor in a stock Go builder container
FROM golang:alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git
WORKDIR  /go/thor
COPY . /go/thor
RUN make all

# Pull thor into a second stage deploy alpine container