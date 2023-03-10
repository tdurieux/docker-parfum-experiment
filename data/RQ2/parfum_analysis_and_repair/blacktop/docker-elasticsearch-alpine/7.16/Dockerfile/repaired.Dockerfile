FROM alpine:3.15

LABEL maintainer "https://github.com/blacktop"

RUN apk add --no-cache openjdk11-jre-headless su-exec

ENV VERSION 7.16.3
ENV DOWNLOAD_URL "https://artifacts.elastic.co/downloads/elasticsearch"
ENV ES_TARBAL "${DOWNLOAD_URL}/elasticsearch-${VERSION}-no-jdk-linux-x86_64.tar.gz"
ENV ES_TARBALL_ASC "${DOWNLOAD_URL}/elasticsearch-${VERSION}-no-jdk-linux-x86_64.tar.gz.asc"
ENV EXPECTED_SHA_URL "${DOWNLOAD_URL}/elasticsearch-${VERSION}-no-jdk-linux-x86_64.tar.gz.sha512"
ENV ES_TARBALL_SHA "ec9747694ba9f8b76b1620e42addd106afa3d3c207dd3836afe2482556f8a982fa03f3536ebb762f12a6093c9a5eac63cdbf2f1941dde9e3ce69c41652749d4f"
ENV GPG_KEY "46095ACC8548582C1A2699A9D27D666CD88E42B4"

RUN apk add --no-cache bash
RUN apk add --no-cache -t .build-deps wget ca-certificates gnupg openssl \
  && set -ex \
  && cd /tmp \
  && echo "===> Install Elasticsearch..." \
  && wget --progress=bar:force -O elasticsearch.tar.gz "$ES_TARBAL"; \
  if [ "$ES_TARBALL_SHA" ]; then \
  echo "$ES_TARBALL_SHA *elasticsearch.tar.gz" | sha512sum -c -; \
  fi; \
  if [ "$ES_TARBALL_ASC" ]; then \
  wget --progress=bar:force -O elasticsearch.tar.gz.asc "$ES_TARBALL_ASC"; \
  export GNUPGHOME="$(mktemp -d)"; \
  ( gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPG_KEY" \
  || gpg --batch --keyserver pgp.mit.edu --recv-keys "$GPG_KEY" \
  || gpg --batch --keyserver keyserver.pgp.com --recv-keys "$GPG_KEY") \
  gpg --batch --verify elasticsearch.tar.gz.asc elasticsearch.tar.gz; \
  rm -rf "$GNUPGHOME" elasticsearch.tar.gz.asc || true; \
  fi; \
  tar -xf elasticsearch.tar.gz \
  && ls -lah \
  && mv elasticsearch-$VERSION /usr/share/elasticsearch \
  && adduser -D -h /usr/share/elasticsearch elasticsearch \
  && echo "===> Creating Elasticsearch Paths..." \
  && for path in \
  /usr/share/elasticsearch/data \
  /usr/share/elasticsearch/logs \
  /usr/share/elasticsearch/config \
  /usr/share/elasticsearch/config/scripts \
  /usr/share/elasticsearch/tmp \
  /usr/share/elasticsearch/plugins \
  ; do \
  mkdir -p "$path"; \
  chown -R elasticsearch:elasticsearch "$path"; \
  done \
  && rm -rf /tmp/* /usr/share/elasticsearch/jdk \
  && apk del --purge .build-deps && rm elasticsearch.tar.gz

# TODO: remove this (it removes X-Pack ML so it works on Alpine)
RUN rm -rf /usr/share/elasticsearch/modules/x-pack-ml/platform/linux-x86_64

COPY config/elastic /usr/share/elasticsearch/config
COPY config/logrotate /etc/logrotate.d/elasticsearch
COPY elastic-entrypoint.sh /
RUN chmod +x /elastic-entrypoint.sh
COPY docker-healthcheck /usr/local/bin/

WORKDIR /usr/share/elasticsearch

ENV PATH /usr/share/elasticsearch/bin:$PATH
ENV ES_TMPDIR /usr/share/elasticsearch/tmp

VOLUME ["/usr/share/elasticsearch/data"]

EXPOSE 9200 9300
ENTRYPOINT ["/elastic-entrypoint.sh"]
CMD ["elasticsearch"]

# HEALTHCHECK CMD ["docker-healthcheck"]
