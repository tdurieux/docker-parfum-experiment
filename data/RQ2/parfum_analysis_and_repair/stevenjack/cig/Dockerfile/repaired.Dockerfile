FROM golang:1.4.2
MAINTAINER Steven Jack <stevenmajack@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends git -yq && rm -rf /var/lib/apt/lists/*;

RUN go get github.com/mitchellh/gox
RUN gox -build-toolchain

WORKDIR /go
