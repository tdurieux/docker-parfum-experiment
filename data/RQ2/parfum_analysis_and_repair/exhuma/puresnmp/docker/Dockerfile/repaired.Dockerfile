FROM python:2.7
WORKDIR /opt/app
RUN apt-get update && apt-get -y --no-install-recommends install snmpd snmp libsnmp-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /opt/app -p

COPY snmpd.conf /etc/snmp/snmpd.conf
COPY send_trap /usr/local/bin
RUN chmod +x /usr/local/bin/send_trap
EXPOSE 161/udp
CMD ["snmpd", "-f", "-V"]
