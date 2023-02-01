FROM alpine
MAINTAINER "Pietro Bertera" <pietro@bertera.it>

RUN apk add --no-cache --update lighttpd \
 && rm -rf /var/cache/apk/*

COPY start.sh /

ENTRYPOINT ["/start.sh"]
