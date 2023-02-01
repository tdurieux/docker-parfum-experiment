ARG BASE_IMAGE=alpine:latest
ARG CORES=${nproc}

FROM ${BASE_IMAGE} as final

RUN apk update

RUN apk add --no-cache --update alpine-sdk \
    && apk add --no-cache cmake openssl openssl-dev g++ \
    curl-dev git autoconf libtool linux-headers \
    boost-dev libevent-dev openssl-dev

RUN mkdir -p /opt/third_party/install

WORKDIR /opt
