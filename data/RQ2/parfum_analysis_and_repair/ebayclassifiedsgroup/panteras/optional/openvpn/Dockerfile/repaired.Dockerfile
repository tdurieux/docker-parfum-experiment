# Leaner build then Ubunutu
FROM ubuntu:14.04.2

MAINTAINER Wojciech Sielski "wsielski@team.mobile.de"

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM xterm
ENV HOME /root

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
      python-pip \
      wget \
      curl \
      unzip \
      dnsutils \
      vim && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir supervisor-stdout
RUN pip install --no-cache-dir https://github.com/Supervisor/supervisor/archive/3.2-branch.zip

RUN apt-get update && \
    apt-get -y build-dep pam && \
    apt-get install --no-install-recommends -y \
      openvpn \
      iptables \
      nslcd \
      nscd && rm -rf /var/lib/apt/lists/*;

# Temporal fix for PAM in container
RUN export CONFIGURE_OPTS=--disable-audit && \
    cd /root && \
    apt-get -b source pam && \
    dpkg -i libpam-doc*.deb libpam-modules*.deb libpam-runtime*.deb libpam0g*.deb

VOLUME ["/etc/openvpn"]

WORKDIR /etc/openvpn

ADD supervisord.conf /etc/supervisord.conf

EXPOSE 1194 1194/udp

ENTRYPOINT [ "supervisord" ]
