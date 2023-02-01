FROM nvidia/cuda:10.1-devel-ubuntu16.04

ENV PATH "/usr/lib/go-1.12/bin:/go/bin:${PATH}"
ENV PKG_CONFIG_PATH "/root/compiled/lib/pkgconfig"
ENV CPATH /usr/local/cuda/include
ENV LIBRARY_PATH /usr/local/cuda/lib64

RUN apt-get update \
  && apt-get install -y software-properties-common \
  && add-apt-repository ppa:longsleep/golang-backports -y && \
  apt-get update && \
  apt-get -y install build-essential pkg-config autoconf gnutls-dev golang-1.12-go sudo git curl python

ENV GOPATH /go
RUN mkdir -p /go
WORKDIR /go/src/github.com/livepeer/go-livepeer
