FROM debian:buster-slim
MAINTAINER jthijssen@bitmaelum.com

# We need CA certificates otherwise we cannot connect to https://
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates netbase && rm -rf /var/lib/apt/lists/*

COPY bm-* /usr/local/bin/

RUN mkdir /etc/bitmaelum && ln -sf /bitmaelum/server-config.yml /etc/bitmaelum/bitmaelum-server-config.yml
COPY docker-entrypoint-suite.sh /usr/local/bin/docker-entrypoint.sh