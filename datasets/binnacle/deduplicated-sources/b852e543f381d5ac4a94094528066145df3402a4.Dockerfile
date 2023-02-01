#
# Docker image for srclib-go
#

# Install dependencies
FROM golang:1.6-alpine

RUN apk --update add git make

# Install srclib-go executable
ENV GOPATH /srclib/toolchains
ENV PATH $PATH:$GOPATH/bin
ENV SRCLIBPATH $GOPATH/src
ARG TOOLCHAIN_URL
ADD $TOOLCHAIN_URL /toolchain/t
RUN (cd /toolchain && tar xfz t && rm t && mv * t) || true
RUN mkdir -p $SRCLIBPATH/sourcegraph.com/sourcegraph && mv /toolchain/t $SRCLIBPATH/sourcegraph.com/sourcegraph/srclib-go
WORKDIR $SRCLIBPATH/sourcegraph.com/sourcegraph/srclib-go
RUN make

# Install srclib binary (assumes this has been built on the Docker host)
ADD ./srclib /bin/srclib

# Run environment
ENV GOPATH /drone
ENTRYPOINT srclib config && srclib make
