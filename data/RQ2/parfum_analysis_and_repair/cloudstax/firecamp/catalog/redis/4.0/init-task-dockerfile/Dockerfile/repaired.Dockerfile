FROM debian:jessie-slim

RUN set -x \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    curl \
    ruby \
    dnsutils \
	&& gem install redis \
  && rm -rf /var/lib/apt/lists/*

COPY redis-cli /
COPY redis-trib.rb /
COPY waitdns.sh /
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

