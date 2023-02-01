FROM ubuntu:20.04

COPY ./blueboat.deb ./run.sh libmimalloc.so* /
RUN apt update && \
  apt install --no-install-recommends -y curl ca-certificates /blueboat.deb && \
  curl -f -L https://github.com/apple/foundationdb/releases/download/6.3.24/foundationdb-clients_6.3.24-1_amd64.deb --output /fdb-client.deb && \
  dpkg -i /fdb-client.deb && \
  rm /blueboat.deb /fdb-client.deb && rm -rf /var/lib/apt/lists/*;
ENV LD_PRELOAD=/libmimalloc.so
ENTRYPOINT /run.sh
