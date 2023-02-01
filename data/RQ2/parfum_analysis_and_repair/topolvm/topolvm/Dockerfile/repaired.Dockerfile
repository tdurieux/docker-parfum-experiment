# Build Container
FROM golang:1.17-buster AS build-env

# Get argment
ARG TOPOLVM_VERSION

COPY . /workdir
WORKDIR /workdir

RUN touch csi/*.go lvmd/proto/*.go \
    && make build-topolvm TOPOLVM_VERSION=${TOPOLVM_VERSION}

# TopoLVM container