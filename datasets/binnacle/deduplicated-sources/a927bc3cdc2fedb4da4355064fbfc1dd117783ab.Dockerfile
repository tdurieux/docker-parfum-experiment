# Builds Suricata Dalton agent using Suricata source tarball
FROM ubuntu:16.04
MAINTAINER David Wharton

ARG SURI_VERSION

# tcpdump is for pcap analysis; not *required* for
#  the agent but nice to have....
RUN apt-get update -y && apt-get install -y \
    python \
    tcpdump \
    libpcre3 libpcre3-dbg libpcre3-dev \
    build-essential autoconf automake libtool libpcap-dev libnet1-dev \
    libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libcap-ng-dev libcap-ng0 \
    make libmagic-dev libjansson-dev libjansson4 pkg-config

# for debugging agent
#RUN apt-get install -y less nano

# download, build, and install Suricata from source
RUN mkdir -p /src/suricata-${SURI_VERSION}
WORKDIR /src
ADD http://downloads.suricata-ids.org/suricata-${SURI_VERSION}.tar.gz suricata-${SURI_VERSION}.tar.gz
RUN tar -zxf suricata-${SURI_VERSION}.tar.gz -C suricata-${SURI_VERSION} --strip-components=1
WORKDIR /src/suricata-${SURI_VERSION}
RUN ./configure --enable-profiling && make -j $(nproc) && make install && make install-conf && ldconfig

RUN mkdir -p /opt/dalton-agent/
WORKDIR /opt/dalton-agent
COPY dalton-agent.py /opt/dalton-agent/dalton-agent.py
COPY dalton-agent.conf /opt/dalton-agent/dalton-agent.conf

CMD python /opt/dalton-agent/dalton-agent.py -c /opt/dalton-agent/dalton-agent.conf 2>&1
