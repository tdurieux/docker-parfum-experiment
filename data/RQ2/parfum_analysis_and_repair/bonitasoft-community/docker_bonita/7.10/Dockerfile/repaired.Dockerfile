FROM ubuntu:18.04

MAINTAINER Jérémy Jacquier-Roux <jeremy.jacquier-roux@bonitasoft.org>

# install packages
RUN apt-get update && apt-get install --no-install-recommends -y \
  curl \
  gnupg2 \
  mysql-client-core-5.7 \
  openjdk-11-jre-headless \
  postgresql-client \
  unzip \
  zip \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /opt/custom-init.d/

# create user to launch Bonita as non-root
RUN groupadd -r bonita -g 1000 \
  && useradd -u 1000 -r -g bonita -d /opt/bonita/ -s /sbin/nologin -c "Bonita User" bonita

# grab gosu
RUN ( gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  || gpg --batch --keyserver ipv4.ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4) \
  && curl -fsSL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture)" -o /usr/local/bin/gosu \
  && curl -fsSL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture).asc" -o /usr/local/bin/gosu.asc \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

# use --build-arg key=value in docker build command to override arguments
ARG BONITA_VERSION
ARG BONITA_SHA256
ARG BASE_URL
ARG BONITA_URL

ENV BONITA_VERSION ${BONITA_VERSION:-7.10.6}
ENV BONITA_SHA256  ${BONITA_SHA256:-aaf61a044e7a8d9ec95d2b5d0c315a6d01d9c93ba01d753fcb008e2cfbbb725f}

ENV BASE_URL ${BASE_URL:-https://github.com/bonitasoft/bonita-platform-releases/releases/download}
ENV BONITA_URL ${BONITA_URL:-${BASE_URL}/${BONITA_VERSION}/BonitaCommunity-${BONITA_VERSION}.zip}
RUN echo "Downloading Bonita from url: $BONITA_URL"

# add Bonita archive to the container
RUN mkdir /opt/files \
  && curl -fsSL ${BONITA_URL} -o /opt/files/BonitaCommunity-${BONITA_VERSION}.zip

# display downloaded checksum
RUN sha256sum /opt/files/BonitaCommunity-${BONITA_VERSION}.zip

# check with expected checksum
RUN echo "$BONITA_SHA256" /opt/files/BonitaCommunity-${BONITA_VERSION}.zip | sha256sum -c -

# create Volume to store Bonita files
VOLUME /opt/bonita

COPY files /opt/files
COPY templates /opt/templates

# expose Tomcat port
EXPOSE 8080

# command to run when the container starts
CMD ["/opt/files/startup.sh"]
