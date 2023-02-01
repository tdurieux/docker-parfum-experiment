FROM golang:1.18 as builder
LABEL maintainer="Moov <support@moov.io>"
RUN apt-get update -qq && apt-get install --no-install-recommends -y git make && rm -rf /var/lib/apt/lists/*;
WORKDIR /go/src/github.com/moov-io/wire
COPY . .
WORKDIR /go/src/github.com/moov-io/wire/test/fuzz-reader
RUN make install
RUN make fuzz-build
ENTRYPOINT make fuzz-run
