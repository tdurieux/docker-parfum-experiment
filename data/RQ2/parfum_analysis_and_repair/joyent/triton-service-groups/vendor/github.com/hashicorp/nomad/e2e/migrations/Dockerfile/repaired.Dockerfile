FROM ubuntu:17.10

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    golang \
    liblxc1 && rm -rf /var/lib/apt/lists/*;

ENV GOPATH=$HOME/gopkg
ENV PATH=$PATH:$GOPATH/bin:/usr/local/lib

COPY nomad /bin/nomad

RUN mkdir -p /nomad/data && \
    mkdir -p /etc/nomad && \
    mkdir -p gopkg/src/github.com/nomad

RUN go get github.com/stretchr/testify/assert
