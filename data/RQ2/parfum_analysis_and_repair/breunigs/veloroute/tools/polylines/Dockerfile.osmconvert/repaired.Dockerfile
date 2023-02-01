FROM debian:stable-slim

RUN apt-get -y update && \
  apt-get -y --no-install-recommends install osmctools && \
  rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/usr/bin/osmconvert"]

