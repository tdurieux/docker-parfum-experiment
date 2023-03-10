FROM golang:1.17-alpine
MAINTAINER CyberArk Software Ltd.
LABEL id="secretless-test-runner"

# On CyberArk dev laptops, golang module dependencies are downloaded with a
# corporate proxy in the middle. For these connections to succeed we need to
# configure the proxy CA certificate in build containers.
#
# To allow this script to also work on non-CyberArk laptops where the CA
# certificate is not available, we copy the (potentially empty) directory
# and update container certificates based on that, rather than rely on the
# CA file itself.
ADD build_ca_certificate /usr/local/share/ca-certificates/
RUN update-ca-certificates

WORKDIR /secretless

RUN apk add --no-cache -u curl \
               gcc \
               git \
               mercurial \
               musl-dev

COPY go.mod go.sum /secretless/
COPY third_party/ /secretless/third_party

RUN go mod download

# go-junit-report => Convert go test output to junit xml
# gocov => converts native coverage output to gocov's JSON interchange format
# gocov-xml => converts gocov format to XML for use with Jenkins/Cobertura
RUN go get -u github.com/jstemmer/go-junit-report && \
    go get github.com/axw/gocov/gocov && \
    go get github.com/AlekSi/gocov-xml
