# This file aimed for developers and optimized for quick re-builds
# Shouild be used by running `make localdocker`
FROM livepeer/ffmpeg-base:latest as builder

FROM golang:1-stretch as builder2

ARG HIGHEST_CHAIN_TAG
ENV PKG_CONFIG_PATH /root/compiled/lib/pkgconfig
WORKDIR /root
RUN apt update \
    && apt install --no-install-recommends -y \
    git gcc g++ gnutls-dev && rm -rf /var/lib/apt/lists/*;
    # git gcc g++ gnutls-dev linux-headers
COPY --from=builder /root/compiled /root/compiled/

ENV PKG_CONFIG_PATH /root/compiled/lib/pkgconfig
WORKDIR /root

COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

COPY . .

RUN echo "Please build using 'make localdocker'"
RUN test -n "$(cat .git.describe)"
RUN go build -tags $HIGHEST_CHAIN_TAG -ldflags="-X github.com/livepeer/go-livepeer/core.LivepeerVersion=$(cat VERSION)-$(cat .git.describe)" -v cmd/livepeer/livepeer.go

FROM debian:stretch-slim

WORKDIR /root
RUN apt update && apt install --no-install-recommends -y ca-certificates jq libgnutls30 && apt clean && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /root/.lpData/mainnet/keystore && \
  mkdir -p /root/.lpData/rinkeby/keystore && \
  mkdir -p /root/.lpData/devenv/keystore && mkdir -p /root/.lpData/offchain/keystore
COPY --from=builder2 /root/livepeer /usr/bin/livepeer

COPY docker/start.sh .
RUN chmod +x start.sh

EXPOSE 7935/tcp
EXPOSE 8935/tcp
EXPOSE 1935/tcp

ENTRYPOINT ["/root/start.sh"]
CMD ["--help"]

# Build Docker image: docker build -t livepeerbinary:debian -f docker/Dockerfile.debian .
