FROM golang:latest

RUN apt-get update && apt-get install --no-install-recommends -y jq && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /go/src/github.com/tepleton/basecoin
WORKDIR /go/src/github.com/tepleton/basecoin

COPY Makefile /go/src/github.com/tepleton/basecoin/
COPY glide.yaml /go/src/github.com/tepleton/basecoin/
COPY glide.lock /go/src/github.com/tepleton/basecoin/

RUN make get_vendor_deps

COPY . /go/src/github.com/tepleton/basecoin
