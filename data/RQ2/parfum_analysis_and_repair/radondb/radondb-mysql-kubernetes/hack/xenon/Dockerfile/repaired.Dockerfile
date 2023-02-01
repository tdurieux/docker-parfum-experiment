##############################################################################
#  Build Xenon
###############################################################################

FROM golang:1.16 as builder

ARG XENON_BRANCH=master
RUN set -ex; \
    mkdir -p /go/src/github.com/radondb; \
    cd /go/src/github.com/radondb; \
    git clone --branch $XENON_BRANCH https://github.com/radondb/xenon.git; \
    cd xenon; \
    go env -w GO111MODULE=off; \
    make build

###############################################################################
#  Docker image for Xenon
###############################################################################

FROM alpine:3.13

RUN set -ex \
    && addgroup -g 1001 mysql && adduser -u 1001 -g 1001 -S mysql \
    && apk add --no-cache curl bash jq \
    && mkdir -p /etc/xenon /var/lib/xenon /lib64 \
    && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 \
    && echo "/etc/xenon/xenon.json" > /config.path \
    # allow to change config files