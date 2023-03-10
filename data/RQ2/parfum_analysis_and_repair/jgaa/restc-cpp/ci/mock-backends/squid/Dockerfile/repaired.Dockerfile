FROM debian:buster
MAINTAINER jarle@jgaa.com

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends upgrade \
 && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install squid3 && rm -rf /var/lib/apt/lists/*;
COPY squid.conf.bin /etc/squid3/squid.conf

EXPOSE 3128/tcp

RUN cat /etc/hosts

CMD squid3 -Nd 1 -f /etc/squid3/squid.conf
