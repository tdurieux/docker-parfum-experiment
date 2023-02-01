# Build Geth in a stock Go builder container
FROM golang:1.12-stretch as builder

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y gcc make git && rm -rf /var/lib/apt/lists/*;

ADD . /go-ethereum

WORKDIR /go-ethereum

RUN make cmd/geth

# Pull Geth into a second stage deploy ubuntu container
FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y openssh-server iputils-ping iperf3 && apt-get clean && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /go-ethereum/bin/geth /usr/local/bin/

EXPOSE 8545 8546 30303 30303/udp
ENTRYPOINT ["geth"]