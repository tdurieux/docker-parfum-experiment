# This Dockerfile is used to build the image available on DockerHub
FROM golang:1.17.9 as build

# Add everything
ADD . /usr/src/multus-cni

ENV GOARCH "arm64"
ENV GOOS "linux"

RUN  cd /usr/src/multus-cni && \
     ./hack/build-go.sh

# build arm64 container