# Memcached Dokku plugin
#
# Version 0.3

FROM ubuntu:trusty
MAINTAINER Jannis Leidel "jannis@leidel.info"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y --no-install-recommends install memcached libmemcached-tools && rm -rf /var/lib/apt/lists/*;

EXPOSE 11211
