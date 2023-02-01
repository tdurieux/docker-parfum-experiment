FROM debian:jessie
RUN apt-get update
RUN apt-get -y --no-install-recommends install \
    libdata-dumper-simple-perl \
    libdbd-pg-perl \
    libdbi-perl \
    libnet-oping-perl \
    libsocket-perl \
    libswitch-perl \
    libtimedate-perl \
    perl \
    libjson-xs-perl \
    libjson-perl \
    perl-base \
    snmpd \
    libsnmp-perl \
    perl-modules && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget tar && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /opt/gondul
COPY build/test/snmpd.conf /etc/snmp/
CMD /opt/gondul/build/test/snmpfetch-misc.sh
EXPOSE 1111
