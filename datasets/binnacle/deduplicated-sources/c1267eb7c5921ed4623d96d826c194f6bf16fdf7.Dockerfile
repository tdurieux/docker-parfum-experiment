#
# This Dockerfile builds a recent base image containing cstor binaries and 
# libraries.
#

FROM openebs/cstor-ubuntu:xenial-20190515

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \ 
    apt-get update && apt-get install -y \
    curl tcpdump dnsutils iputils-ping \
    libaio1 libaio-dev \
    libkqueue-dev libssl1.0.0 rsyslog net-tools gdb apt-utils \
    sed libjemalloc-dev
RUN apt-get -y install apt-file && apt-file update

COPY zfs/bin/* /usr/local/bin/
COPY zfs/lib/* /usr/lib/

ARG BUILD_DATE
LABEL org.label-schema.name="cstor"
LABEL org.label-schema.description="OpenEBS cStor"
LABEL org.label-schema.url="http://www.openebs.io/"
LABEL org.label-schema.vcs-url="https://github.com/openebs/openebs"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE

EXPOSE 7676
