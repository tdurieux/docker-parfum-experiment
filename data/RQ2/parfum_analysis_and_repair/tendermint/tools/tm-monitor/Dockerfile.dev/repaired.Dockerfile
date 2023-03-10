FROM golang:latest

RUN mkdir -p /go/src/github.com/tendermint/tools/tm-monitor
WORKDIR /go/src/github.com/tendermint/tools/tm-monitor

COPY Makefile /go/src/github.com/tendermint/tools/tm-monitor/

RUN make get_tools

COPY . /go/src/github.com/tendermint/tools/tm-monitor

RUN make get_vendor_deps