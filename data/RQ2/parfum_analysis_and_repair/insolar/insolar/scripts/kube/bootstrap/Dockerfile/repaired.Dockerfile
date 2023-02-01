# 1) build step (approx local build time ~4m w/o cache)
ARG GOLANG_VERSION=1.12
FROM golang:${GOLANG_VERSION}

ADD . /go/src/github.com/insolar/insolar
WORKDIR /go/src/github.com/insolar/insolar

# pass build variables as arguments to avoid adding .git directory
ARG BUILD_NUMBER
ARG BUILD_DATE
ARG BUILD_TIME
ARG BUILD_HASH
ARG BUILD_VERSION
# build step