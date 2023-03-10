FROM komljen/jdk-oracle
MAINTAINER Alen Komljen <alen.komljen@live.com>

RUN \
  apt-get update && \
  apt-get -y --no-install-recommends install \
          maven && \
  rm -rf /var/lib/apt/lists/*
