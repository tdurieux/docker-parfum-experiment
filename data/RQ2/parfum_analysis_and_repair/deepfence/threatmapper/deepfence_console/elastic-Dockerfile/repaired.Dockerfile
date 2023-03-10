FROM alpine:3.13.6
MAINTAINER Deepfence Inc
LABEL deepfence.role=system

ENV VERSION=7.10.2 \
    DOWNLOAD_URL="https://artifacts.elastic.co/downloads/elasticsearch"
ENV ES_TARBAL="${DOWNLOAD_URL}/elasticsearch-oss-${VERSION}-no-jdk-linux-x86_64.tar.gz" \
    ES_TARBALL_ASC="${DOWNLOAD_URL}/elasticsearch-oss-${VERSION}-no-jdk-linux-x86_64.tar.gz.asc" \
    EXPECTED_SHA_URL="${DOWNLOAD_URL}/elasticsearch-oss-${VERSION}-no-jdk-linux-x86_64.tar.gz.sha512" \
    ES_TARBALL_SHA="7b63237996569ccdc7c9d9e7cc097fcb23865396eddac30e5f02543484220d2fc70a7285b430877e5e76a5d8716d9682de9fc40d5e57a08f331e82011fc59756" \
    GPG_KEY="46095ACC8548582C1A2699A9D27D666CD88E42B4" \
    PATH=/usr/share/elasticsearch/bin:$PATH \
    ES_TMPDIR=/usr/share/elasticsearch/tmp \
    TAKE_FILE_OWNERSHIP=1 \
    ES_MEM="2g" \
    DF_PROG_NAME="es_master"
ENV bootstrap.memory_lock true
ENV cluster.name=df-es-cluster
ENV path.data=/usr/share/elasticsearch/data
ENV path.logs=/usr/share/elasticsearch/logs


RUN apk update --no-cache && apk upgrade --no-cache \
    && apk add --no-cache openjdk11-jre-headless su-exec bash \
    && apk add --no-cache -t .build-deps wget ca-certificates gnupg openssl \
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
    ( gpg --batch --keyserver keys.openpgp.org --recv-keys "$GPG_KEY" \
    || gpg --batch --keyserver pgp.mit.edu --recv-keys "$GPG_KEY" \
    || gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$GPG_KEY" \
    || gpg --batch --keyserver keyserver.pgp.com --recv-keys "$GPG_KEY") \
    gpg --batch --verify elasticsearch.tar.gz.asc elasticsearch.tar.gz; \
    rm -rf "$GNUPGHOME" elasticsearch.tar.gz.asc || true; \
    fi; \
    tar -xf elasticsearch.tar.gz \
    && ls -lah \
    && mv elasticsearch-$VERSION /usr/share/elasticsearch \
#    && rm /usr/share/elasticsearch/modules/ingest-geoip/jackson-databind-*.jar /usr/share/elasticsearch/modules/transport-netty4/netty-transport-*.Final.jar \
#    && rm /usr/share/elasticsearch/modules/transport-netty4/netty-codec-*.Final.jar /usr/share/elasticsearch/modules/transport-netty4/netty-buffer-*.Final.jar \
#    && rm /usr/share/elasticsearch/modules/transport-netty4/netty-codec-http-*.Final.jar /usr/share/elasticsearch/modules/transport-netty4/netty-common-4.1.43.Final.jar \
#    && rm /usr/share/elasticsearch/modules/transport-netty4/netty-handler-*.Final.jar /usr/share/elasticsearch/modules/transport-netty4/netty-resolver-4.1.43.Final.jar \
#    && wget -O /usr/share/elasticsearch/modules/ingest-geoip/jackson-databind-2.10.2.jar "https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.10.2/jackson-databind-2.10.2.jar" \
#    && wget -O /usr/share/elasticsearch/modules/transport-netty4/netty-transport-4.1.45.Final.jar "https://repo1.maven.org/maven2/io/netty/netty-transport/4.1.45.Final/netty-transport-4.1.45.Final.jar" \
#    && wget -O /usr/share/elasticsearch/modules/transport-netty4/netty-codec-4.1.45.Final.jar "https://repo1.maven.org/maven2/io/netty/netty-codec/4.1.45.Final/netty-codec-4.1.45.Final.jar" \
#    && wget -O /usr/share/elasticsearch/modules/transport-netty4/netty-codec-http-4.1.45.Final.jar "https://repo1.maven.org/maven2/io/netty/netty-codec-http/4.1.45.Final/netty-codec-http-4.1.45.Final.jar" \
#    && wget -O /usr/share/elasticsearch/modules/transport-netty4/netty-buffer-4.1.45.Final.jar "https://repo1.maven.org/maven2/io/netty/netty-buffer/4.1.45.Final/netty-buffer-4.1.45.Final.jar" \
#    && wget -O /usr/share/elasticsearch/modules/transport-netty4/netty-common-4.1.45.Final.jar "https://repo1.maven.org/maven2/io/netty/netty-common/4.1.45.Final/netty-common-4.1.45.Final.jar" \
#    && wget -O /usr/share/elasticsearch/modules/transport-netty4/netty-handler-4.1.45.Final.jar "https://repo1.maven.org/maven2/io/netty/netty-handler/4.1.45.Final/netty-handler-4.1.45.Final.jar" \
#    && wget -O /usr/share/elasticsearch/modules/transport-netty4/netty-resolver-4.1.45.Final.jar "https://repo1.maven.org/maven2/io/netty/netty-resolver/4.1.45.Final/netty-resolver-4.1.45.Final.jar" \
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
    && apk del --purge .build-deps \
    && rm -rf /var/cache/apk/* \
    && rm -rf /usr/share/elasticsearch/modules/x-pack-ml/platform/linux-x86_64 && rm elasticsearch.tar.gz
# TODO: remove this (it removes X-Pack ML so it works on Alpine)

COPY elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
# RUN /usr/share/elasticsearch/bin/elasticsearch-plugin remove x-pack \
COPY startEs.sh /usr/bin/
COPY es-jvm.options /usr/share/elasticsearch/config/jvm.options
USER root
#USER elasticsearch
#COPY --from=build /go/check-postgres /usr/local/bin/check-postgres
RUN mkdir /data \
    && chmod 755 /usr/bin/startEs.sh \
    && chown -R elasticsearch:elasticsearch /data \
    && apk add --no-cache zip \
    && zip -q -d /usr/share/elasticsearch/lib/log4j-core-2.11.1.jar org/apache/logging/log4j/core/lookup/JndiLookup.class \
    && apk del --purge zip
#&& chmod 755 /usr/local/bin/check-postgres
EXPOSE 9200 9300
ENTRYPOINT ["/usr/bin/startEs.sh"]
CMD ["elasticsearch"]
