FROM alpine:edge

RUN \
 echo "@testing http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
apk update && \
apk add --upgrade apk-tools && \
apk add supervisor shadow bash py3-pip deluge@testing && \
apk add --no-cache --virtual .pip-build-deps make g++ autoconf python3-dev libffi-dev libressl-dev && \
 pip install --no-cache-dir automat incremental constantly service_identity && \
apk del .pip-build-deps && \
rm -rf /var/cache/apk/*

ADD supervisor.d/* /etc/supervisor.d/
ADD home/ /home/nobody/

RUN chmod +x /home/nobody/*.sh && chmod +x /home/nobody/*.py
RUN chown -R nobody:nobody /usr/bin/supervisord /usr/bin/deluged /usr/bin/deluge-web /etc/supervisord.conf /etc/supervisor.d/ /var/log /var/run/ /home/nobody/
USER nobody

# map /config to host defined config path (used to store configuration from app)
VOLUME /config

# map /data to host defined data path (used to store data from app)
VOLUME /data

# expose port for http
EXPOSE 8112

# expose port for deluge daemon
EXPOSE 58846

# expose port for incoming torrent data (tcp and udp)
EXPOSE 58946
EXPOSE 58946/udp

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf", "-n"]