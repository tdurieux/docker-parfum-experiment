FROM ubuntu:xenial

ENV PATH=/usr/lib/go-1.9/bin:$PATH

RUN \
  apt-get update && apt-get upgrade -q -y && \
  apt-get install -y --no-install-recommends golang-1.9 git make gcc libc-dev ca-certificates && \
  git clone --depth 1 https://github.com/truechain/truechain-engineering-code && \
  (cd truechain-engineering-code && make getrue) && \
  cp truechain-engineering-code/build/bin/getrue /getrue && \
  apt-get remove -y golang-1.9 git make gcc libc-dev && apt autoremove -y && apt-get clean && \
  rm -rf /truechain-engineering-code && rm -rf /var/lib/apt/lists/*;

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/getrue"]
