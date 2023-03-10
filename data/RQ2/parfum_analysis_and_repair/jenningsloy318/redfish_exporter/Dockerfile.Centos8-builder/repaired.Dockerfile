FROM docker.io/library/centos:8

LABEL maintainer="Jennings Liu <jenningsloy318@gmail.com>"

ARG ARCH=amd64

ENV GOROOT /usr/local/go
ENV GOPATH /go
ENV PATH "$GOROOT/bin:$GOPATH/bin:$PATH"
ENV GO_VERSION 1.15.2
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.cn


# Build dependencies

RUN yum update -y && \
    yum install -y  rpm-build make  git && \
    curl -f -SL https://dl.google.com/go/go${GO_VERSION}.linux-${ARCH}.tar.gz | tar -xzC /usr/local && rm -rf /var/cache/yum
