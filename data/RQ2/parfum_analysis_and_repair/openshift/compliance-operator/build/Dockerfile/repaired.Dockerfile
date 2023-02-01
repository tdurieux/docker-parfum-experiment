# Step one: build compliance-operator
FROM golang:1.17 AS builder

WORKDIR /go/src/github.com/openshift/compliance-operator

ENV GOFLAGS=-mod=vendor

COPY . . 
RUN make manager

# Step two: containerize compliance-operator
FROM registry.access.redhat.com/ubi8/ubi-micro:latest

ENV OPERATOR=/usr/local/bin/compliance-operator \
    USER_UID=1001 \
    USER_NAME=compliance-operator

# install operator binary