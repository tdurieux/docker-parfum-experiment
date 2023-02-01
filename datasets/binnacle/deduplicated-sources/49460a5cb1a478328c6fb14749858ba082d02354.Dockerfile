# Builds Snort 2.9.x.x Dalton agent using Snort source
# Works for Snort 2.9.1.1 and later; previous versions are more
#  nuanced with libraries and compile dependencies so if you need
#  a previous version, just build your own.
FROM ubuntu:16.04
MAINTAINER David Wharton

ARG SNORT_VERSION
ARG DAQ_VERSION

# tcpdump is for pcap analysis; not *required* for
#  the agent but nice to have....
RUN apt-get update -y && apt-get install -y \
    python \
    tcpdump \
    build-essential make flex bison \
    libpcap-dev libpcre3-dev \
    libcap-ng-dev libdumbnet-dev \
    zlib1g-dev liblzma-dev openssl libssl-dev \
    libnghttp2-dev libluajit-5.1-dev && ldconfig

# for debugging agent
#RUN apt-get install -y less nano

# download, build, and install Snort from source
RUN mkdir -p /src/snort-${SNORT_VERSION} && mkdir -p /etc/snort
WORKDIR /src
# DAQ.  Apparenlty DAQ will sometime fail building with multiple make jobs.
ADD https://www.snort.org/downloads/archive/snort/daq-${DAQ_VERSION}.tar.gz daq-${DAQ_VERSION}.tar.gz
RUN tar -zxf daq-${DAQ_VERSION}.tar.gz && cd daq-${DAQ_VERSION} && ./configure && make && make install
# Snort
ADD https://www.snort.org/downloads/archive/snort/snort-${SNORT_VERSION}.tar.gz snort-${SNORT_VERSION}.tar.gz
RUN tar -zxf snort-${SNORT_VERSION}.tar.gz -C snort-${SNORT_VERSION} --strip-components=1 && \
    cd /src/snort-${SNORT_VERSION} && ./configure --enable-sourcefire && make -j $(nproc) && make install && \
    mkdir /usr/local/lib/snort_dynamicrules && ldconfig

RUN cp -t /etc/snort/ /src/snort-${SNORT_VERSION}/etc/classification.config /src/snort-${SNORT_VERSION}/etc/file_magic.conf \
    /src/snort-${SNORT_VERSION}/etc/gen-msg.map /src/snort-${SNORT_VERSION}/etc/reference.config \
    /src/snort-${SNORT_VERSION}/etc/threshold.conf /src/snort-${SNORT_VERSION}/etc/unicode.map; exit 0

RUN mkdir -p /opt/dalton-agent/
WORKDIR /opt/dalton-agent
COPY dalton-agent.py /opt/dalton-agent/dalton-agent.py
COPY dalton-agent.conf /opt/dalton-agent/dalton-agent.conf

CMD python /opt/dalton-agent/dalton-agent.py -c /opt/dalton-agent/dalton-agent.conf 2>&1
