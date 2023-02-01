FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common build-essential wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://dl.google.com/go/go1.16.3.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.16.3.linux-amd64.tar.gz && rm go1.16.3.linux-amd64.tar.gz

ENV GOPATH=$HOME/go
ENV PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

WORKDIR /go/src/github.com/MinterTeam/minter-go-node
