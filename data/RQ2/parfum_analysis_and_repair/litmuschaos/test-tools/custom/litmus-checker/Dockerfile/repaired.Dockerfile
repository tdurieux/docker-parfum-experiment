#Build Stage
FROM golang:1.14 AS builder

LABEL maintainer="LitmusChaos"

ARG TARGETOS=linux
ARG TARGETARCH

ADD . /chaos-checker
WORKDIR /chaos-checker

ENV GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH}

RUN go env

RUN CGO_ENABLED=0 go build -o /output/checker -v

#Deploy Stage
FROM alpine:latest

LABEL maintainer="LitmusChaos"

#Install kubectl
#Copy binaries from build stage