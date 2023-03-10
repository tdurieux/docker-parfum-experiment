# Note: the image is nearly 3x bigger under ubuntu than alpine
FROM ubuntu:20.04
MAINTAINER Rich Braun "docker@instantlinux.net"
ARG BUILD_DATE
ARG VCS_REF
LABEL org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.license=Apache-2.0 \
    org.label-schema.name=nagiosql \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url=https://github.com/instantlinux/docker-tools

ENV APACHE_BIN=apache2 \
    APACHE_USER=www-data \
    DB_HOST=db00 \
    DB_NAME=nagiosql \
    DB_PASSWD_SECRET=nagiosql-db-password \
    DB_PORT=3306 \
    DB_USER=nagiosql \
    TZ=UTC

ARG DEBIAN_FRONTEND=noninteractive
ARG NAGIOS_GID=1000
ARG NAGIOS_UID=999
ARG NAGIOSQL_VERSION=3.4.1
ARG NAGIOSQL_SHA=a2b280b1178f7d26a66068c41faba5a38f8575d5cafe32836d7a2594d7e217ad
ARG NAGIOSQL_DOWNLOAD=nagiosql-$NAGIOSQL_VERSION-git2020-01-19.tar.bz2

COPY src /tmp/
RUN apt-get update && \
    apt-get install --no-install-recommends -y apache2 bzip2 curl libapache2-mod-php php gettext \
      php-mysql php-ssh2 tzdata && apt-get clean && rm -rf /var/lib/apt/lists/*;
RUN \
    echo 'date.timezone = UTC' > /etc/php/7.4/apache2/conf.d/50-tz.ini && \
    echo 'include_path = ".:/var/www/nagiosql/libraries/pear"' \
      > /etc/php/7.4/apache2/conf.d/50-include.ini && \
    cd /tmp && \
    curl -f -sLo $NAGIOSQL_DOWNLOAD \
      https://sourceforge.net/projects/nagiosql/files/nagiosql/NagiosQL%20${NAGIOSQL_VERSION}/${NAGIOSQL_DOWNLOAD} && \
    echo "$NAGIOSQL_SHA  $NAGIOSQL_DOWNLOAD" | sha256sum -c && \
    mkdir /var/www/nagiosql && \
    tar xjf $NAGIOSQL_DOWNLOAD -C /var/www/nagiosql --strip-components=1 && \
    groupadd -g $NAGIOS_GID nagios && \
    useradd -u $NAGIOS_UID -c Nagios -s /sbin/nologin -g nagios nagios && \
    usermod -G nagios $APACHE_USER && \
    mv /tmp/nagiosql.conf /etc/apache2/conf-enabled/ && \
    mv /tmp/settings.php.j2 /var/www/nagiosql/config/ && \
    rm -fr /tmp/* /var/log/[b-w]*

COPY html /var/www/html
RUN chmod a+rX /var/www/html
EXPOSE 80

VOLUME /opt/nagios/etc /opt/nagios/var
COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
