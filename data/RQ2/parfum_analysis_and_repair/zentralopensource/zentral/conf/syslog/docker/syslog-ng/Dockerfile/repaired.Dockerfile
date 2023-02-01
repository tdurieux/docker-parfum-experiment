FROM debian:latest
MAINTAINER Éric Falconnier <eric.falconnier@112hz.com>

RUN apt-get update -qq && apt-get upgrade && apt-get install --no-install-recommends -y syslog-ng && rm -rf /var/lib/apt/lists/*;

COPY syslog-ng.conf /etc/syslog-ng/syslog-ng.conf

EXPOSE 514/udp 610/tcp

ENTRYPOINT ["/usr/sbin/syslog-ng", "--no-caps", "-F"]
