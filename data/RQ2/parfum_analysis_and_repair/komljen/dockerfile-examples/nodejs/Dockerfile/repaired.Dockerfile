FROM komljen/ubuntu
MAINTAINER Alen Komljen <alen.komljen@live.com>

RUN \
  add-apt-repository -y ppa:chris-lea/node.js && \
  apt-get update && \
  apt-get -y --no-install-recommends install \
          nodejs && \
  rm -rf /var/lib/apt/lists/*
