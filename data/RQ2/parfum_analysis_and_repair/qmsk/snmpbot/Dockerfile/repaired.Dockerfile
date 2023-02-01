## build go backend
FROM golang:1.15-buster as go-build

WORKDIR /go/src/github.com/qmsk/snmpbot

# dependencies
COPY go.mod go.sum ./
RUN go mod download

# source code
COPY . ./
RUN go install -v ./cmd/...


## download mibs
FROM buildpack-deps:stretch-scm as get-mibs

ARG SNMPBOT_MIBS_VERSION=0.1.0

RUN curl -fsSL https://github.com/qmsk/snmpbot-mibs/archive/v${SNMPBOT_MIBS_VERSION}.tar.gz | tar -C /tmp -xzv


## runtime
# must match with go-build base image