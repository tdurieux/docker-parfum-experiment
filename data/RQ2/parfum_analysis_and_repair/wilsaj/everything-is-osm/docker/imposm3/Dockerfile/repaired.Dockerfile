FROM ubuntu:14.04

ENV IMPOSM_VERSION 32623ccce097584be79ec8617dfae42d595ac2b8

# Build imposm3 binary and clean up afterwards
RUN apt-get update \
    && apt-get install --no-install-recommends -y golang \
    && apt-get install --no-install-recommends -y git \
    && apt-get install --no-install-recommends -y libgeos++-dev \
    && apt-get install --no-install-recommends -y libleveldb-dev \
    && apt-get install --no-install-recommends -y libprotobuf-dev \
    && apt-get install --no-install-recommends -y libsqlite3-dev \
    && apt-get install --no-install-recommends -y mercurial \
    && mkdir /imposm \
    && git clone https://github.com/omniscale/imposm3 /imposm/src/imposm3 \
    && cd /imposm/src/imposm3 \
    && git checkout $IMPOSM_VERSION \
    && GOPATH=/imposm go get imposm3 \
    && GOPATH=/imposm go build -o /imposm3 imposm3 \
    && cd / \
    && rm -rf /imposm \
    && apt-get purge -y --auto-remove golang \
    && apt-get purge -y --auto-remove git \
    && apt-get purge -y --auto-remove mercurial && rm -rf /var/lib/apt/lists/*;

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

VOLUME /everything-is-osm

COPY import.sh /import.sh
COPY mapping.json /everything-is-osm/mapping.json
RUN mkdir -p /everything-is-osm/metro
