FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -yq \
        rsyslog \
        rsyslog-gnutls \
        rsyslog-mysql \
        rsyslog-pgsql \
        rsyslog-elasticsearch \
        rsyslog-mongodb \
        rsyslog-relp \
    && \
    echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list.d/stretch-backports.list && \
    apt-get update && apt-get -t stretch-backports --no-install-recommends install -yq \
        rsyslog-kafka \
        rsyslog-hiredis \
    && \
    echo 'global(processInternalMessages="off")' > /etc/rsyslog.conf && \
    echo '$IncludeConfig /etc/rsyslog.d/*.conf' >> /etc/rsyslog.conf && rm -rf /var/lib/apt/lists/*;

EXPOSE 514 514/udp

VOLUME [ "/etc/rsyslog.d" ]

ENTRYPOINT [ "rsyslogd", "-n", "-f", "/etc/rsyslog.conf", "-i", "/tmp/rsyslog.pid" ]
