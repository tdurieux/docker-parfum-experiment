FROM golang:1.17.8-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends clang && rm -rf /var/lib/apt/lists/*;

ENV CGO_ENABLED 1
ENV CXX clang++

COPY . /go-zetasql

WORKDIR /go-zetasql
