ARG BASE_IMAGE=balenalib/raspberry-pi2-debian:jessie

FROM $BASE_IMAGE

USER root

#RUN apt-get update && \
#    apt-get install -y --force-yes unzip unrar-free mediainfo curl wget


ENV build_deps="automake build-essential ca-certificates libc-ares-dev libcppunit-dev libtool libssl-dev libxml2-dev libncurses5-dev pkg-config subversion zlib1g-dev"
RUN apt-get update && \
    apt-get install -q -y --no-install-recommends ${build_deps} \
    openssl \
    ca-certificates \
    libc-ares2 && \
    apt-get autoremove -y; apt-get clean; rm /var/lib/apt/lists/* -r; rm -rf /usr/share/man/*

WORKDIR /usr/local/src

CMD ["./configure", "$CONFIGURE"]