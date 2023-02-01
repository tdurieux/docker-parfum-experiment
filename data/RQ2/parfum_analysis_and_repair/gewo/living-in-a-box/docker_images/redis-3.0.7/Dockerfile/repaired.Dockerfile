# Redis Server (gewo/redis)
FROM gewo/redis-base
MAINTAINER Gebhard Wöstemeyer <g.woestemeyer@gmail.com>

ENV VERSION 3.0.7

RUN \
  wget https://download.redis.io/releases/redis-${VERSION}.tar.gz && \
  tar xvfz redis-${VERSION}.tar.gz && \
  cd redis-${VERSION} && make redis-server && cd - && \
  mv redis-${VERSION}/src/redis-server /usr/bin && \
  rm -rf redis-${VERSION}* && rm redis-${VERSION}.tar.gz
