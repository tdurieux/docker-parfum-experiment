# This file aimed for developers and optimized for quick re-builds
# Shouild be used by running `make localdocker`
FROM livepeer/ffmpeg-base:latest as builder

FROM golang:1-stretch as builder2
ENV PKG_CONFIG_PATH /root/compiled/lib/pkgconfig
WORKDIR /root
RUN apt update \
    && apt install -y \
    git gcc g++ gnutls-dev 
    # git gcc g++ gnutls-dev linux-headers
COPY --from=builder /root/compiled /root/compiled/

ENV PKG_CONFIG_PATH /root/compiled/lib/pkgconfig
WORKDIR /go/src/github.com/livepeer/go-livepeer

RUN go get github.com/golang/glog
RUN go get -u -v github.com/livepeer/m3u8
RUN go get github.com/aws/aws-sdk-go/aws
RUN go get -u google.golang.org/grpc
RUN go get github.com/pkg/errors
RUN go get github.com/stretchr/testify/mock
RUN go get -u -v go.opencensus.io/stats
RUN go get -u -v go.opencensus.io/tag
RUN go get -u -v contrib.go.opencensus.io/exporter/prometheus

COPY vendor vendor
# .dockerbuild.deps contains list of packages used by go-client
# needed to build them before building our code so it will be cached
# by docker and reused on next builds.
# it was generated manually by running `go build -v` and capturing output
# should be updated only if we remove some dependency from vendor dir
COPY .dockerbuild.deps .dockerbuild.deps

# this will pre-build and cache files in /vendor dir
RUN go list -v -export $(cat .dockerbuild.deps)

# ipfs, monitor and pm dirs special cased as presumanbly being
# less frequent changed
# adding 'export` to other dirs probably won't add any improvements
# to re-build speed
COPY ipfs ipfs
RUN go list -v -export github.com/livepeer/go-livepeer/ipfs
COPY monitor monitor
RUN go list -v -export github.com/livepeer/go-livepeer/monitor
COPY pm pm
RUN go list -v -export github.com/livepeer/go-livepeer/pm
COPY VERSION VERSION


COPY cmd cmd
COPY common common
COPY core core
COPY server server
COPY discovery discovery
COPY drivers drivers
COPY net net
COPY eth eth
COPY .git.describe .git.describe

RUN echo "Please build using 'make localdocker'"
RUN test -n "$(cat .git.describe)"
RUN go build -ldflags="-X github.com/livepeer/go-livepeer/core.LivepeerVersion=$(cat VERSION)-$(cat .git.describe)" -v cmd/livepeer/livepeer.go

FROM debian:stretch-slim

WORKDIR /root
RUN apt update && apt install -y  ca-certificates jq libgnutls30 && apt clean
RUN mkdir -p /root/.lpData/mainnet/keystore && \
  mkdir -p /root/.lpData/rinkeby/keystore && \
  mkdir -p /root/.lpData/devenv/keystore && mkdir -p /root/.lpData/offchain/keystore
COPY --from=builder2 /go/src/github.com/livepeer/go-livepeer/livepeer /usr/bin/livepeer

COPY docker/start.sh .
RUN chmod +x start.sh

EXPOSE 7935/tcp
EXPOSE 8935/tcp
EXPOSE 1935/tcp

ENTRYPOINT ["/root/start.sh"]
CMD ["--help"]

# Build Docker image: docker build -t livepeerbinary:debian -f docker/Dockerfile.debian .
