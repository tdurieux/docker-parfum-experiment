FROM jprjr/ubuntu-base:14.04
MAINTAINER John Regan <john@jrjrtech.com>

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y --no-install-recommends install dnsmasq && \
    cp /etc/dnsmasq.conf /opt/dnsmasq.conf.default && \
    mkdir /etc/s6/dnsmasq && \
    ln -s /bin/true /etc/s6/dnsmasq/finish && rm -rf /var/lib/apt/lists/*;

ADD copyconf.sh /opt/copyconf.sh
ADD dnsmasq.run /etc/s6/dnsmasq/run

EXPOSE 53
