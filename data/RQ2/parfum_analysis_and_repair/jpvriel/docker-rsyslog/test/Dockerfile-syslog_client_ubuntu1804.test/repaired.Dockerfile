FROM ubuntu:18.04
LABEL application="rsyslog_test_client_ubuntu1804"

ENV container=docker

RUN apt-get update && apt-get install -y --no-install-recommends \
  rsyslog \
  rsyslog-gnutls \
  rsyslog-relp \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/etc/ssl/test

RUN rm -r /etc/rsyslog.d/ \
  && rm /etc/rsyslog.conf
COPY ubuntu1804/etc/ /etc/
COPY rsyslog_test_client.sh /usr/local/bin
RUN chmod +x /usr/local/bin/rsyslog_test_client.sh

VOLUME /var/spool/rsyslog

ENTRYPOINT ["/usr/local/bin/rsyslog_test_client.sh"]