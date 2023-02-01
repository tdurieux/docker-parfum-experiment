FROM alpine:3.8 as solc_builder
RUN \
  apk --no-cache --update add build-base cmake boost-dev git; \
  sed -i -E -e 's/include <sys\/poll.h>/include <poll.h>/' /usr/include/boost/asio/detail/socket_types.hpp; \
  git clone --depth 1 --recursive -b v0.4.24 https://github.com/ethereum/solidity; \
  cd /solidity && cmake -DCMAKE_BUILD_TYPE=Release -DTESTS=0 -DSTATIC_LINKING=1 && \
  touch prerelease.txt && make -j8 solc && install -s solc/solc /usr/bin; \
  cd / && rm -rf solidity; \
  apk del sed build-base git make cmake gcc g++ musl-dev curl-dev boost-dev; \
  rm -rf /var/cache/apk/*

FROM alpine:3.8 as go_builder
RUN \
  apk add --no-cache --virtual .build-deps bash gcc musl-dev openssl go; \
  wget -O go.src.tar.gz https://dl.google.com/go/go1.15.7.src.tar.gz; \
  tar -C /usr/local -xzf go.src.tar.gz; rm go.src.tar.gz \
  cd /usr/local/go/src/ && ./make.bash; \
  apk del .build-deps

FROM alpine:3.8
RUN apk add --no-cache ca-certificates boost git make gcc libc-dev curl bash python python-dev py-pip
RUN pip install --no-cache-dir awscli-local
COPY --from=solc_builder /usr/bin/solc /usr/bin/solc
COPY --from=go_builder /usr/local/go /usr/local

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.24.0
