FROM ubuntu:xenial
MAINTAINER "https://github.com/tehraven"
# BUILDS tehraven/alpinewebos:redis

RUN apt-get update && apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;

EXPOSE 6379

CMD  ["/usr/bin/redis-server"]