FROM snowplow-docker-registry.bintray.io/snowplow/base-alpine:0.2.0
LABEL maintainer="Snowplow Analytics Ltd. <support@snowplowanalytics.com>"

# The version of the loader to download.
ENV ELASTICSEARCH_LOADER_VERSION="0.10.2"

# The name of the archive to download.
ENV ARCHIVE="snowplow_elasticsearch_loader_http_${ELASTICSEARCH_LOADER_VERSION}.zip"

# Install the ElasticSearch Loader.
RUN mkdir -p /tmp/build && \
    cd /tmp/build && \
    wget -q http://dl.bintray.com/snowplow/snowplow-generic/${ARCHIVE} && \
    unzip -d ${SNOWPLOW_BIN_PATH} ${ARCHIVE} && \
    cd /tmp && \
    rm -rf /tmp/build

# Defines an entrypoint script delegating the lauching of the loader to the snowplow user.
# The script uses dumb-init as the top-level process.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "--help" ]
