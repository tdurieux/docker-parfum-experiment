#
#  Author: Hari Sekhon
#  Date: 2016-05-18 18:10:20 +0100 (Wed, 18 May 2016)
#
#  vim:ts=4:sts=4:sw=4:et
#
#  https://github.com/HariSekhon/Dockerfiles
#
#  If you're using my code you're welcome to connect with me on LinkedIn
#  and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

# not basing on official solr as it doesn't have SolrCloud 4.x which I want to keep using for my test suite
# nosemgrep: dockerfile.audit.dockerfile-source-not-pinned.dockerfile-source-not-pinned
FROM alpine:3.12

ARG SOLRCLOUD_VERSION=7.7.1

LABEL org.opencontainers.image.description="SolrCloud" \
      org.opencontainers.image.version="$SOLRCLOUD_VERSION" \
      org.opencontainers.image.authors="Hari Sekhon (https://www.linkedin.com/in/HariSekhon)" \
      org.opencontainers.image.url="https://ghcr.io/HariSekhon/solrcloud" \
      org.opencontainers.image.documentation="https://hub.docker.com/r/harisekhon/solrcloud" \
      org.opencontainers.image.source="https://github.com/HariSekhon/Dockerfiles"

ARG TAR="solr-$SOLRCLOUD_VERSION.tgz"

ENV PATH $PATH:/solr/bin

WORKDIR /

# SolrCloud solr -e cloud asks for lsof to detect if something is listening on 8983
# Solr start script needs jar or unzip to extract war
RUN set -eux && \
    apk add --no-cache bash openjdk8-jre-base lsof

RUN set -eux && \
    apk add --no-cache wget tar && \
    # Solr 4+ only
    url="http://www.apache.org/dyn/closer.lua?filename=lucene/solr/$SOLRCLOUD_VERSION/$TAR&action=download"; \
    url_archive="http://archive.apache.org/dist/lucene/solr/$SOLRCLOUD_VERSION/$TAR"; \
    #for x in {1..10}; do wget -t 10 --retry-connrefused -c -O "$TAR" "$url" && break; done && \
    # --max-redirect - some apache mirrors redirect a couple times and give you the latest version instead
    #                  but this breaks stuff later because the link will not point to the right dir
    #                  (and is also the wrong version for the tag)
    wget -t 10 --max-redirect 1 --retry-connrefused -O "${TAR}" "$url" || \
    wget -t 10 --max-redirect 1 --retry-connrefused -O "${TAR}" "$url_archive" && \
    tar zxf "$TAR" && \
    # check tarball was extracted to the right place, helps ensure it's the right version and the link will work