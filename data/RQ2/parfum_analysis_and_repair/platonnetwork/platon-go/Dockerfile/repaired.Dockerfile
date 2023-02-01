# Build PlatON in a stock Go builder container
FROM golang:1.16-alpine3.13 as builder

RUN apk add --no-cache make gcc musl-dev linux-headers g++ llvm bash cmake git gmp-dev openssl-dev

ADD . /PlatON-Go
RUN cd /PlatON-Go && make clean && make platon

# Pull PlatON into a second stage deploy alpine container