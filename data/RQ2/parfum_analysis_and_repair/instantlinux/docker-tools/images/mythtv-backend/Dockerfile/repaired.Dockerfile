FROM ubuntu:focal
MAINTAINER Rich Braun "docker@instantlinux.net"
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.license=GPL-2.0 \
    org.label-schema.name=mythtv-backend \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url=https://github.com/instantlinux/docker-tools

ENV APACHE_LOG_DIR=/var/log/apache2 \
    DBNAME=mythtv \
    DBSERVER=db00 \
    DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LOCALHOSTNAME= \
    TZ=UTC

ARG APT_KEY=13551B881504888C
ARG MYTHTV_GID=100
ARG MYTHTV_UID=2021
ARG MYTHTV_PPA=http://ppa.launchpad.net/mythbuntu/31
ARG MYTHTV_VERSION=2:31.0+fixes.202203040618.7e4ce1ba98~ubuntu20.04.1
ARG SSH_PORT=2022
ARG MYTHWEB_PORT=6760

RUN \
  apt-get -yq update && apt-get install --no-install-recommends -yq gnupg locales wget && \
  apt-key adv --recv-keys --keyserver keyserver.ubuntu.com $APT_KEY && \
  echo "deb $MYTHTV_PPA/ubuntu focal main" \
    > /etc/apt/sources.list.d/mythbuntu.list && \
  apt-get -yq update && \
  locale-gen $LANG && \
  apt-get -yq --no-install-recommends install \
    apache2 curl iputils-ping less lsb-release mariadb-client net-tools \
    openssh-client openssh-server mythtv-backend=$MYTHTV_VERSION \
    mythtv-common=$MYTHTV_VERSION mythtv-transcode-utils=$MYTHTV_VERSION \
    mythweb=$MYTHTV_VERSION libmyth-python php-mythtv psmisc sudo tzdata \
    v4l-utils vim w3m x11-utils xauth xmltv xterm && rm -rf /var/lib/apt/lists/*;

COPY src/ /root/

RUN \
  sed -i -e "s/Listen 80/Listen $MYTHWEB_PORT/" /etc/apache2/ports.conf && \
  sed -i -e "s/#Port 22/Port $SSH_PORT/" /etc/ssh/sshd_config && \
  mv /root/mythweb.conf /root/mythweb-settings.conf \
    /etc/apache2/sites-available/ && \
  usermod -u $MYTHTV_UID -s /bin/bash mythtv && \
  mkdir -p /var/lib/mythtv $APACHE_LOG_DIR && \
  echo "mythtv:mythtv" | chpasswd && \
  chown $MYTHTV_UID:$MYTHTV_GID /var/lib/mythtv
RUN \
  cat /etc/apache2/ports.conf

EXPOSE $MYTHWEB_PORT $SSH_PORT 5000/udp 5002/udp 5004/udp 6543 6544 6549 \
  65001 65001/udp
VOLUME $APACHE_LOG_DIR
ENTRYPOINT ["/root/entrypoint.sh"]
