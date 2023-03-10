# Bareos director Dockerfile
FROM ubuntu:focal

LABEL maintainer="barcus@tou.nu"

ARG BUILD_DATE
ARG NAME
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$NAME \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/barcus/bareos" \
      org.label-schema.version=$VERSION

ENV DEBIAN_FRONTEND noninteractive
ENV BAREOS_KEY http://download.bareos.org/bareos/release/20/xUbuntu_20.04/Release.key
ENV BAREOS_REPO http://download.bareos.org/bareos/release/20/xUbuntu_20.04/
ENV BAREOS_DPKG_CONF bareos-database-common bareos-database-common

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update -qq \
 && apt-get -qq -y install --no-install-recommends curl tzdata gnupg \
 && curl -Ls $BAREOS_KEY -o /tmp/bareos.key \
 && apt-key --keyring /etc/apt/trusted.gpg.d/breos-keyring.gpg \
    add /tmp/bareos.key \
 && echo "deb $BAREOS_REPO /" > /etc/apt/sources.list.d/bareos.list \
 && echo "${BAREOS_DPKG_CONF}/dbconfig-install boolean false" \
    | debconf-set-selections \
 && echo "${BAREOS_DPKG_CONF}/install-error select ignore" \
    | debconf-set-selections \
 && echo "${BAREOS_DPKG_CONF}/database-type select pgsql" \
    | debconf-set-selections \
 && echo "${BAREOS_DPKG_CONF}/missing-db-package-error select ignore" \
    | debconf-set-selections \
 && echo 'postfix postfix/main_mailer_type select No configuration' \
    | debconf-set-selections \
 && apt-get update -qq \
 && apt-get install -qq -y --no-install-recommends \
    bareos postgresql-client bareos-tools mysql-client \
 && apt-get install -qq -y --no-install-recommends \
    bareos-database-mysql \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN tar czf /bareos-dir.tgz /etc/bareos

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod u+x /docker-entrypoint.sh

VOLUME /etc/bareos

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["echo", "[!] Migration successful"]
