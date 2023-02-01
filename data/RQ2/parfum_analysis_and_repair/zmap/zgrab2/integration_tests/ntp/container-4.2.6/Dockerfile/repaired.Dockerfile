FROM zgrab2_service_base:latest

# This image grabs the 4.2.6p5 source release of NTP and builds it.

RUN apt-get install --no-install-recommends -y libssl-dev gcc g++ make binutils autoconf wget tar && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt
RUN wget https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.6p5.tar.gz
RUN tar -xzf ntp-4.2.6p5.tar.gz && rm ntp-4.2.6p5.tar.gz

WORKDIR /opt/ntp-4.2.6p5
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"
RUN make

# Don't require authentication, don't fork, debug level 10
ENTRYPOINT [ "/opt/ntp-4.2.6p5/ntpd/ntpd", "-A", "-n", "-D", "10" ]
