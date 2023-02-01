# Build GMC in a stock Go builder container
FROM golang:1.9-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /go-musicoin
RUN cd /go-musicoin && make gmc

# Pull GMC into a second stage deploy alpine container