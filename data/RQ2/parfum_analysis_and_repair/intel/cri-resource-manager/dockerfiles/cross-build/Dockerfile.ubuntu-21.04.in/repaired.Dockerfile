# pull in base + a minimal set of useful packages
FROM ubuntu:21.04 as ubuntu-21.04-build

ARG GOLANG_VERSION=x.yz
ARG GOLANG_URLDIR=https://dl.google.com/go
ARG CREATE_USER="test"
ARG USER_OPTIONS=""
ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV DEBIAN_FRONTEND noninteractive

# pull in stuff for building