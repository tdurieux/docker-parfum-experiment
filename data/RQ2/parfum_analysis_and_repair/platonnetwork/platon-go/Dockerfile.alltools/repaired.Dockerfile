# Build Geth in a stock Go builder container
FROM golang:1.15-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers g++ llvm bash cmake git gmp-dev openssl-dev

RUN git clone https://github.com/dfinity/bn.git
RUN cd bn && make && make install

ADD . /PlatON-Go
RUN cd /PlatON-Go && make clean && make platon

# Pull Geth into a second stage deploy alpine container