FROM debian:stretch
MAINTAINER Seán C McCord "scm@cycoresys.com"

RUN apt-get update && \
    apt-get install --no-install-recommends -y curl procps gnupg2 sngrep && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install kamailio
RUN curl -f -qO http://deb.kamailio.org/kamailiodebkey.gpg && \
    apt-key add kamailiodebkey.gpg && \
    echo "deb http://deb.kamailio.org/kamailio52 stretch main\ndeb-src http://deb.kamailio.org/kamailio52 stretch main" > /etc/apt/sources.list.d/kamailio.list
RUN apt-get update && apt-get install --no-install-recommends -y kamailio kamailio-json-modules kamailio-utils-modules kamailio-extra-modules kamailio-nth && apt-get clean && rm -rf /var/lib/apt/lists/*;

# Download netdiscover
RUN curl -f -qL -o /usr/bin/netdiscover https://github.com/CyCoreSystems/netdiscover/releases/download/v1.2.5/netdiscover.linux.amd64
RUN chmod +x /usr/bin/netdiscover

# Install config and templates
ADD config /etc/kamailio
ADD dispatcher.list /data/kamailio/dispatcher.list

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD []
