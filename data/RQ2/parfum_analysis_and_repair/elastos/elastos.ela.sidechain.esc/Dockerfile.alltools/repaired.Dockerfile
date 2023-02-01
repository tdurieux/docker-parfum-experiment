# Build Geth in a stock Go builder container
FROM golang:1.13-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers git

ADD . /Elastos.ELA.SideChain.ESC
RUN cd /Elastos.ELA.SideChain.ESC && make all

# Pull all binaries into a second stage deploy alpine container