FROM alpine:3.5

RUN \
  apk add --no-cache --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 https://github.com/Musicoin/go-musicoin && \
  (cd go-ethereum && make gmc) && \
  cp go-ethereum/build/bin/gmc /gmc && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-ethereum && rm -rf /var/cache/apk/*

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/gmc"]
