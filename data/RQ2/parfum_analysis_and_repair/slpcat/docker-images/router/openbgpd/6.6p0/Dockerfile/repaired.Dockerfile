FROM debian:stable

MAINTAINER Pier Carlo Chiodi <pierky@pierky.com>

EXPOSE 179

RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    build-essential \
    curl \
    flex \
    git \
    libreadline-dev \
    libncurses5-dev \
    libtool \
    m4 \
    unzip \
    byacc && rm -rf /var/lib/apt/lists/*;

RUN groupadd _bgpd && \
    useradd -g _bgpd -s /sbin/nologin -d /var/empty -c 'OpenBGPD daemon' _bgpd && \
    mkdir -p /var/empty && \
    chown 0 /var/empty && \
    chgrp 0 /var/empty && \
    chmod 0755 /var/empty

# This directory must be mounted as a local volume with '-v `pwd`/bgpd:/etc/bgpd:rw' docker's command line option.
# The host's file at `pwd`/bgpd/bgpd.conf is used as the configuration file for OpenBGPD.
RUN mkdir /etc/bgpd

WORKDIR /root
RUN curl -f -L https://github.com/openbgpd-portable/openbgpd-portable/archive/6.6p0.zip -o 6.6p0.zip

RUN unzip 6.6p0.zip

RUN cd /root/openbgpd-portable-6.6p0 && \
    ./autogen.sh && \
    YACC=byacc ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --sysconfdir=/etc/bgpd && \
    make && \
    make install

CMD /usr/local/sbin/bgpd -f /etc/bgpd/bgpd.conf -d
