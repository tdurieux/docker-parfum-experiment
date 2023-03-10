FROM debian:jessie-slim

# pub   4096R/A15703C6 2016-01-11 [expires: 2018-01-10]
#       Key fingerprint = 0C49 F373 0359 A145 1858  5931 BC71 1F9B A157 03C6
# uid                  MongoDB 3.4 Release Signing Key <packaging@mongodb.com>
ENV GPG_KEYS \
	0C49F3730359A14518585931BC711F9BA15703C6

# https://docs.mongodb.com/manual/tutorial/verify-mongodb-packages/#download-then-import-the-key-file
RUN set -ex; \
  export GNUPGHOME="$(mktemp -d)"; rm -rf -d \
  for key in $GPG_KEYS; do \
    gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
  done; \
  gpg --batch --export $GPG_KEYS > /etc/apt/trusted.gpg.d/mongodb.gpg; \
  rm -r "$GNUPGHOME"; \
  apt-key list

# Allow build-time overrides (eg. to build image with MongoDB Enterprise version)
# Options for MONGO_PACKAGE: mongodb-org OR mongodb-enterprise
# Options for MONGO_REPO: repo.mongodb.org OR repo.mongodb.com
# Example: docker build --build-arg MONGO_PACKAGE=mongodb-enterprise --build-arg MONGO_REPO=repo.mongodb.com .
ARG MONGO_PACKAGE=mongodb-org
ARG MONGO_REPO=repo.mongodb.org
ENV MONGO_PACKAGE=${MONGO_PACKAGE} MONGO_REPO=${MONGO_REPO}

ENV MONGO_MAJOR 3.4
ENV MONGO_VERSION 3.4.10

RUN echo "deb http://$MONGO_REPO/apt/debian jessie/${MONGO_PACKAGE}/$MONGO_MAJOR main" | tee "/etc/apt/sources.list.d/${MONGO_PACKAGE}.list"


RUN set -x \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y \
    curl \
    dnsutils \
		${MONGO_PACKAGE}-shell=$MONGO_VERSION \
		${MONGO_PACKAGE}-mongos=$MONGO_VERSION \
	&& rm -rf /var/lib/apt/lists/*

COPY waitdns.sh /
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
