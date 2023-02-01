FROM debian:buster

RUN apt-get update && \
    apt-get install --no-install-recommends -y snmpd snmp snmptrapd && rm -rf /var/lib/apt/lists/*;

COPY snmpd.conf /etc/snmp/snmpd.conf

CMD ["/usr/sbin/snmpd", "-f", "-V", "-Lo", "-u", "Debian-snmp", "-g", "Debian-snmp", "-I", "-smux,mteTrigger,mteTriggerConf"]
