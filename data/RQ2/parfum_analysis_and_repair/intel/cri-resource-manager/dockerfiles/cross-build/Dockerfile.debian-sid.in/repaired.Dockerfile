# pull in base + a minimal set of useful packages
FROM debian:sid as debian-sid-build

ARG GOLANG_VERSION=x.yz
ARG GOLANG_URLDIR=https://dl.google.com/go
ARG CREATE_USER="test"
ARG USER_OPTIONS=""
ENV PATH /go/bin:/usr/local/go/bin:$PATH

# pull in stuff for cgo