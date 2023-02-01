# Step one: build file-integrity-operator
FROM golang:1.17 as builder
USER root

WORKDIR /go/src/github.com/openshift/file-integrity-operator

ENV GOFLAGS="-mod=vendor"

COPY . .

RUN make build

# Step two: containerize file-integrity-operator and AIDE together
FROM registry.fedoraproject.org/fedora-minimal:latest
RUN microdnf -y install aide golang && microdnf clean all

ENV OPERATOR=/usr/local/bin/file-integrity-operator \
    USER_UID=1001 \
    USER_NAME=file-integrity-operator

# install operator binary