FROM debian:jessie
MAINTAINER Kaliop

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    haproxy \
    procps \
    rsyslog \
    curl; rm -rf /var/lib/apt/lists/*;

ADD haproxy.cfg /etc/haproxy/haproxy.cfg


ADD bootstrap.sh /root/bootstrap.sh

# Clear archives in apt cache folder
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/root/bootstrap.sh"]

EXPOSE 80 443 8000