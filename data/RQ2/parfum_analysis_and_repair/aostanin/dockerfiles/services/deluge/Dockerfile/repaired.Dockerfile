FROM ubuntu:trusty

ENV LANG en_US.UTF-8
RUN locale-gen $LANG

RUN apt-get install --no-install-recommends -qy software-properties-common && \
    add-apt-repository ppa:deluge-team/ppa && \
    apt-get update -q && \
    apt-get install --no-install-recommends -qy deluged deluge-web && rm -rf /var/lib/apt/lists/*;

ADD start.sh /start.sh

VOLUME ["/data"]
# Torrent port
EXPOSE 53160
EXPOSE 53160/udp
# WebUI
EXPOSE 8112
# Daemon
EXPOSE 58846

CMD ["/start.sh"]
