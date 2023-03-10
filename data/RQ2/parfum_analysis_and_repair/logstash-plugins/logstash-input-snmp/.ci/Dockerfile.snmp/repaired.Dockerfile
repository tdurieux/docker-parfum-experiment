FROM ubuntu:20.04

ARG PORT

RUN mkdir -p /share && apt-get update && apt-get -y --no-install-recommends install snmpd snmp libsnmp-dev && rm -rf /var/lib/apt/lists/*;

COPY snmpd.conf /etc/snmp/
RUN sed -ie "s/:161/:$PORT/g" /etc/snmp/snmpd.conf && \
    net-snmp-create-v3-user -ro -A STrP@SSPhr@sE -a SHA -X STr0ngP@SSWRD$PORT -x AES user_1  && \
    net-snmp-create-v3-user -ro -A AWeP@SSPhr@sE -a SHA -X AWeS0meP@SSWRD$PORT -x AES user_2

EXPOSE $PORT $PORT/udp

ENTRYPOINT ["snmpd", "-f", "-L"]