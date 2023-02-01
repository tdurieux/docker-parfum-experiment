FROM ubuntu:18.04

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y bind9 && rm -rf /var/lib/apt/lists/*;

COPY docker/testbed/dns/files/named.conf.local /etc/bind/named.conf.local
COPY docker/testbed/dns/files/team.scoringengine.db /etc/bind/team.scoringengine.db

RUN chown root:bind /etc/bind/named.conf.local
RUN chown root:bind /etc/bind/team.scoringengine.db

CMD ["/usr/sbin/named", "-f", "-c", "/etc/bind/named.conf"]

EXPOSE 53/udp
EXPOSE 53

