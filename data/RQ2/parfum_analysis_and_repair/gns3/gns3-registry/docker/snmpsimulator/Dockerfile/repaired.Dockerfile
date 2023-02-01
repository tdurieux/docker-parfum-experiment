FROM debian
RUN apt-get update && apt-get install --no-install-recommends -qqy snmpsim && rm -rf /var/lib/apt/lists/*;
RUN useradd snmp
CMD snmpsimd --agent-udpv4-endpoint=0.0.0.0:1161 --process-user=snmp --process-group=snmp
