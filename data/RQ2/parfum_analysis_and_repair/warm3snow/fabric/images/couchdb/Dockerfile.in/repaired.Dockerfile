# Copyright Greg Haskins All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
FROM _BASE_NS_/fabric-baseimage:_BASE_TAG_

# Based on https://github.com/klaemo/docker-couchdb/blob/master/2.0.0/Dockerfile

# Add CouchDB user account
RUN groupadd -r couchdb && useradd -d /opt/couchdb -g couchdb couchdb

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    erlang-nox \
    erlang-reltool \
    haproxy \
    libicu5. \
    libmozjs185-1.0 \
    openssl \
    cmake \
    apt-transport-https \
    gcc \
    g++ \
    erlang-dev \
    libcurl4-openssl-dev \
    libicu-dev \
    libmozjs185-dev \
    make \
  && rm -rf /var/lib/apt/lists/*

# Grab su-exec and tini
RUN set -x \
    && git clone https://github.com/ncopa/su-exec /tmp/su-exec/ \
    && cd /tmp/su-exec \
    && make all \
    && cp su-exec /usr/bin/ \
    && git clone https://github.com/krallin/tini/ /tmp/tini/ \
    && cd /tmp/tini/ \
    && git checkout v0.14.0 \
    && cmake . && make \
    && cp tini tini-static /usr/local/bin/ \
    # Clean up su-exec and tini
    && rm -rf /tmp/tini \
    && rm -rf /tmp/su-exec

ARG COUCHDB_VERSION=2.0.0

# Download dev dependencies
RUN set -x \
 && npm install -g grunt-cli \
 # Acquire CouchDB source code
 && cd /usr/src && mkdir couchdb \
 && curl -fSL https://dist.apache.org/repos/dist/release/couchdb/source/$COUCHDB_VERSION/apache-couchdb-$COUCHDB_VERSION.tar.gz -o couchdb.tar.gz \
 && tar -xzf couchdb.tar.gz -C couchdb --strip-components=1 \
 && cd couchdb \
 # Build the release and install into /opt \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-docs \
 && make release \
 && mv /usr/src/couchdb/rel/couchdb /opt/ \
 # Cleanup build detritus
 && rm -rf /var/lib/apt/lists/* /usr/lib/node_modules /usr/src/couchdb* && npm cache clean --force; && rm couchdb.tar.gz

# Add configuration
COPY payload/local.ini /opt/couchdb/etc/local.d/
COPY payload/vm.args /opt/couchdb/etc/
COPY payload/docker-entrypoint.sh /

# Setup directories and permissions
RUN chmod +x /docker-entrypoint.sh \
 && mkdir /opt/couchdb/data /opt/couchdb/etc/default.d \
 && chown -R couchdb:couchdb /opt/couchdb/

WORKDIR /opt/couchdb
EXPOSE 5984 4369 9100

VOLUME ["/opt/couchdb/data"]

ENTRYPOINT ["tini", "--", "/docker-entrypoint.sh"]
CMD ["/opt/couchdb/bin/couchdb"]
