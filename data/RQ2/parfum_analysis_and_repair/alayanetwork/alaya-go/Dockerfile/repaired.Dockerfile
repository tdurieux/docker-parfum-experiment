# Build Alaya in a stock Go builder container
FROM golang:1.16-alpine3.13 as builder

RUN apk add --no-cache make gcc musl-dev linux-headers g++ llvm bash cmake git gmp-dev openssl-dev

ADD . /Alaya-Go
RUN cd /Alaya-Go && make clean && make alaya

# Pull Alaya into a second stage deploy alpine container