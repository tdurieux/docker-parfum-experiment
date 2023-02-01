FROM golang:1.18-alpine

RUN apk upgrade --no-cache && \
  apk add --no-cache --virtual .build-deps \
    bash \
    lsof \
    git \
    sysstat \
    attr \
    make \
    util-linux \
    curl \
  ;

COPY deploy/dev/local/aisnode_config.sh /etc/ais/aisnode_config.sh
ENV GOBIN $GOPATH/bin

COPY . $GOPATH/src/github.com/NVIDIA/aistore/
WORKDIR $GOPATH/src/github.com/NVIDIA/aistore

RUN make node