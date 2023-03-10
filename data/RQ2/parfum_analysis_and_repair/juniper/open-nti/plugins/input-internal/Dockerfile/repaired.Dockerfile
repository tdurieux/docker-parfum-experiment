FROM juniper/pyez:2.0.1

WORKDIR /source
USER root

## To be removed once change merge upstream
RUN apk add --no-cache ca-certificates && \
    update-ca-certificates
RUN apk add --no-cache wget git

ARG TELEGRAF_VERSION=1.2.1

#############################
## Install Telegraf
#############################
RUN wget -q https://dl.influxdata.com/telegraf/releases/telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz && \
    mkdir -p /usr/src /etc/telegraf && \
    tar -C /usr/src -xzf telegraf-${TELEGRAF_VERSION}-static_linux_amd64.tar.gz && \
    mv /usr/src/telegraf*/telegraf.conf /etc/telegraf/ && \
    chmod +x /usr/src/telegraf*/* && \
    cp -a /usr/src/telegraf*/* /usr/bin/ && \
    rm -rf *.tar.gz* /usr/src /root/.gnupg

COPY start-input-internal.sh /source/start-input-internal.sh
RUN chmod +x /source/start-input-internal.sh

RUN mkdir /data
ADD templates /data/templates/
WORKDIR /data

CMD ["/source/start-input-internal.sh"]