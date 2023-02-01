# bump: debian-buster-slim /FROM debian:(.*)/ docker:debian|/^buster-.*-slim/|sort
FROM debian:buster-20220711-slim
MAINTAINER Mattias Wadman mattias.wadman@gmail.com
RUN \
  apt-get update && \
  apt-get -y --no-install-recommends install \
    procps \
    postfix \
    libsasl2-modules \
    opendkim \
    opendkim-tools \
    ca-certificates \
    rsyslog && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
    /etc/rsyslog.conf
# Default config:
# Open relay, trust docker links for firewalling.
# Try to use TLS when sending to other smtp servers.
# No TLS for connecting clients, trust docker network to be safe