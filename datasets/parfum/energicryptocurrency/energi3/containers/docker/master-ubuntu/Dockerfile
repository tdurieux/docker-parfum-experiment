FROM ubuntu:xenial

ENV PATH=/usr/lib/go-1.9/bin:$PATH

RUN \
  apt-get update && apt-get upgrade -q -y && \
  apt-get install -y --no-install-recommends golang-1.9 git make gcc libc-dev ca-certificates && \
  git clone --depth 1 --branch release/1.8 https://github.com/ethereum/go-ethereum && \
  (cd go-ethereum && make geth) && \
  cp go-ethereum/build/bin/energi3 /energi3 && \
  apt-get remove -y golang-1.9 git make gcc libc-dev && apt autoremove -y && apt-get clean && \
  rm -rf /go-ethereum

EXPOSE 39796
EXPOSE 39797

ENTRYPOINT ["/energi3"]
