FROM golang:latest

RUN mkdir -p /go/src/github.com/tendermint/abci
WORKDIR /go/src/github.com/tendermint/abci

COPY Makefile /go/src/github.com/tendermint/abci/

# see make protoc for details on ldconfig
RUN make get_protoc && ldconfig

# killall is used in tests
RUN apt-get update && apt-get install --no-install-recommends -y \
    psmisc \
 && rm -rf /var/lib/apt/lists/*

COPY Gopkg.toml /go/src/github.com/tendermint/abci/
COPY Gopkg.lock /go/src/github.com/tendermint/abci/
RUN make get_tools

# see https://github.com/golang/dep/issues/1312
RUN dep ensure -vendor-only

COPY . /go/src/github.com/tendermint/abci
