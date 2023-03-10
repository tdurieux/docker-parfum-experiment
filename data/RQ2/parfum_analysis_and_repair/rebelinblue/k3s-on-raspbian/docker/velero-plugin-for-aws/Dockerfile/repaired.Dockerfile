#
# Compile
#

FROM golang:1.16-alpine as build

ARG VELERO_AWS_PLUGIN_VERSION

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOARCH=arm64 \
    GOOS=linux

WORKDIR /go/src/github.com/vmware-tanzu/velero-plugin-for-aws

RUN apk add --no-cache curl ca-certificates git
RUN git clone https://github.com/vmware-tanzu/velero-plugin-for-aws.git .
RUN git checkout ${VELERO_AWS_PLUGIN_VERSION}
RUN go build -o /go/bin/velero-plugin-for-aws ./velero-plugin-for-aws

#
# Deploy
#