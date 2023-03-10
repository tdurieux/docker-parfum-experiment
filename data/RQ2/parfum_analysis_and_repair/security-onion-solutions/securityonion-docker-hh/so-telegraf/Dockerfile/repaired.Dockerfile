FROM alpine:3.6
LABEL maintainer "Security Onion Solutions, LLC"
LABEL description="Telegraf running in Docker container for use with Security Onion"

RUN echo 'hosts: files dns' >> /etc/nsswitch.conf
RUN apk add --no-cache iputils ca-certificates net-snmp-tools procps lm_sensors redis curl jq && \
    update-ca-certificates

ENV TELEGRAF_VERSION 1.10.1

RUN set -ex && \
    apk add --no-cache --virtual .build-deps wget gnupg tar && \
    for key in \
        05CE15085FC09D18E99EFB22684A14CF2582E0C5; do \
        
   
        gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
        gpg --batch --keyserver pgp.mit.edu --recv-keys "$key" || \
        gpg --batch --keyserver keyserver.pgp.com --recv-keys "$key"; \
       done \
    && \
    wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz.asc && \
    wget --no-verbose https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz && \
    gpg --batch --verify telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz.asc telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz && \
    mkdir -p /usr/src /etc/telegraf && \
    tar -C /usr/src -xzf telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz && \
    mv /usr/src/telegraf*/telegraf.conf /etc/telegraf/ && \
    chmod +x /usr/src/telegraf*/* && \
    cp -a /usr/src/telegraf*/* /usr/bin/ && \
    rm -rf *.tar.gz* /usr/src /root/.gnupg && \
    apk del .build-deps

EXPOSE 8125/udp 8092/udp 8094

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["telegraf"]
