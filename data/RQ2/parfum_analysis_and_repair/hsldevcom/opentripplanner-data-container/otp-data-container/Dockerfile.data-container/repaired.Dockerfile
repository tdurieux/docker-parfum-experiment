FROM       alpine:latest
MAINTAINER Digitransit version: 0.1

RUN apk add --update --no-cache \
  lighttpd \
  lighttpd-mod_auth \
  busybox \
  && rm -rf /var/cache/apk/*

ADD lighttpd.conf /etc/lighttpd/lighttpd.conf
RUN printf '#!/bin/sh\ngrep -v "#" /etc/lighttpd/lighttpd.conf |grep port > /dev/null\nif [ "$?" = "1" ]\nthen\n  echo "server.port = $PORT" >> /etc/lighttpd/lighttpd.conf\nfi\n/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf 2>&1' > /usr/sbin/startlighttpd && chmod 755 /usr/sbin/startlighttpd

ENV PORT="8080"
EXPOSE 8080

ADD *.zip  /var/www/localhost/htdocs/
ADD version.txt /var/www/localhost/htdocs/
ADD build.log /var/www/localhost/htdocs/
ADD router/connected.csv /var/www/localhost/htdocs/
ADD router/unconnected.csv /var/www/localhost/htdocs/

CMD /bin/ash -c "cd var/www/localhost/htdocs/;unzip router*.zip;cp router-*/* .;rm -r \$(find ./ -type d|grep router);cd -;/usr/sbin/startlighttpd"