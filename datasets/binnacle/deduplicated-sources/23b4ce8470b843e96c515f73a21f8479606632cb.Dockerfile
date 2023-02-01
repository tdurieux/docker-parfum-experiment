FROM alpine:latest
MAINTAINER Boris Gorbylev <ekho@ekho.name>

ENV REMOTEDIR 'rsync://<host>[/path]' \
    PASSWORD '******' \
    LOCALDIR '/'

VOLUME /eursync/data

RUN apk add --update --no-cache \
      lighttpd \
      lighttpd-mod_auth \
      lockfile-progs \
      rsync \
      tini \
 && rm -rf /var/cache/apk/* \
 && chgrp -R lighttpd /eursync \
 && chmod -R g+rw /eursync

EXPOSE 80
WORKDIR /eursync

ADD assets/scripts/* /eursync/
ADD assets/lighttpd/* /etc/lighttpd/

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/eursync/eursync.start.sh", "full"]
