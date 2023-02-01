FROM %%OrgName%%firecamp-cassandra:3.11

RUN set -ex; \
  apt-get update; \
  apt-get install --no-install-recommends -y \
    curl \
    dnsutils; \
  rm -rf /var/lib/apt/lists/*

COPY waitdns.sh /
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
