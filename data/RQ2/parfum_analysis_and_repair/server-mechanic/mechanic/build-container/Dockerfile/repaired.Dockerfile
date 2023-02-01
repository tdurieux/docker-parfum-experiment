FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
	&& apt-get install --no-install-recommends -y git bash make python2.7 sqlite3 && rm -rf /var/lib/apt/lists/*;

VOLUME /build
