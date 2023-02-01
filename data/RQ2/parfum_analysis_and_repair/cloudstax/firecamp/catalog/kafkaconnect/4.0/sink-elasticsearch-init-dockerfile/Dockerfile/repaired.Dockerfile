FROM debian:jessie-slim

RUN set -x \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    curl \
    dnsutils \
  && rm -rf /var/lib/apt/lists/*

COPY waitdns.sh /
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

