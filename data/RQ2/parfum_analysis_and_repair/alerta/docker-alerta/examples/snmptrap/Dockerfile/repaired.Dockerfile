FROM ubuntu

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    python3-pip \
    snmptrapd \
    snmp \
    snmp-mibs-downloader && rm -rf /var/lib/apt/lists/*;

ENV MIBS +ALL

ADD snmptrapd.conf.sh /snmptrapd.conf.sh
RUN /snmptrapd.conf.sh

RUN pip3 install --no-cache-dir git+https://github.com/alerta/alerta-contrib.git#subdirectory=integrations/snmptrap

EXPOSE 162/udp

CMD ["snmptrapd", "-f", "-Lo", "-n", "-m+ALL", "-Dtrap"]
