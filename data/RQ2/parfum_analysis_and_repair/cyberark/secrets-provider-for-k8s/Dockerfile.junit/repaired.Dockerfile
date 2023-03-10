FROM golang:1.17-alpine
MAINTAINER CyberArk Software Ltd.
LABEL id="secrets-provider-for-k8s-junit-processor"

WORKDIR /test

RUN apk add --no-cache -u curl \
               gcc \
               git \
               mercurial \
               musl-dev \
               bash

# gocov converts native coverage output to gocov's JSON interchange format
# gocov-xml converts gocov format to XML for use with Jenkins/Cobertura
RUN go get -u github.com/jstemmer/go-junit-report && \
    go get github.com/axw/gocov/gocov && \
    go get github.com/AlekSi/gocov-xml
