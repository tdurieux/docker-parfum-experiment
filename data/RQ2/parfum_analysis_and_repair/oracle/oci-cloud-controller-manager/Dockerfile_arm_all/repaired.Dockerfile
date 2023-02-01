ARG CI_IMAGE_REGISTRY

FROM golang:1.17.3 as builder

ARG COMPONENT

ENV SRC /go/src/github.com/oracle/oci-cloud-controller-manager

ENV GOPATH /go/
RUN mkdir -p /go/bin $SRC
ADD . $SRC

WORKDIR $SRC

RUN ARCH=arm make clean build-arm-all

FROM arm64v8/oraclelinux:7-slim

RUN yum install -y util-linux \
  && yum install -y e2fsprogs \
  && yum clean all && rm -rf /var/cache/yum
 \

COPY --from=0 /go/src/github.com/oracle/oci-cloud-controller-manager/dist/arm/* /usr/local/bin/
