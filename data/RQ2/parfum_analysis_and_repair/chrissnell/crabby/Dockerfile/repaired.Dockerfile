FROM ubuntu:16.04

MAINTAINER Chris Snell <chris.snell@gmail.com>

RUN apt-get update && apt-get -y --no-install-recommends install curl ca-certificates && rm -rf /var/lib/apt/lists/*;

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.9
RUN set -x \
	&& curl -f -L -o /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& curl -f -L -o /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true && rm -rf -d

VOLUME ["/config"]

ADD crabby /crabby

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
