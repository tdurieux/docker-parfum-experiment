FROM ubuntu:focal

RUN set -ex; \
  apt-get update; \
  apt-get install -qy --no-install-recommends curl; \
  rm -rf /var/lib/apt/lists/*

COPY ./out/admiral /usr/local/admiral

RUN chmod +x /usr/local/admiral

ENTRYPOINT ["/usr/local/admiral"]