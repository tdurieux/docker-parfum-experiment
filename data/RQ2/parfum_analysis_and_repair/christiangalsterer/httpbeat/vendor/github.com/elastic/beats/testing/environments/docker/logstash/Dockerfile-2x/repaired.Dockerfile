FROM java:8-jre

ARG LOGSTASH_VERSION

ENV DEB_URL https://download.elastic.co/logstash/logstash/packages/debian/logstash-${LOGSTASH_VERSION}_all.deb

ENV PATH $PATH:/opt/logstash/bin:/opt/logstash/vendor/jruby/bin

# install logstash
RUN set -x && \
    mkdir -p /var/tmp && \
    wget -qO /var/tmp/logstash.deb $DEB_URL && \
    apt-get update -y && \
    apt-get install --no-install-recommends -y logrotate git && \
    dpkg -i /var/tmp/logstash.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN plugin install logstash-input-beats

COPY logstash.conf.tmpl /logstash.conf.tmpl
COPY docker-entrypoint.sh /entrypoint.sh

COPY pki /etc/pki

ENTRYPOINT ["/entrypoint.sh"]

CMD logstash agent -f /logstash.conf


