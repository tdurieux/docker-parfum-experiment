FROM alpine:3.9
MAINTAINER Thomas Spicer (thomas@openbridge.com)

ENV VAR_PREFIX=/var/run
ENV LOG_PREFIX=/var/log/php-fpm
ENV TEMP_PREFIX=/tmp
ENV CACHE_PREFIX=/var/cache

RUN set -x \
  && addgroup -g 82 -S www-data \
  && adduser -u 82 -D -S -h /var/cache/php-fpm -s /sbin/nologin -G www-data www-data \
  && apk add --no-cache --virtual .build-deps \
      wget \
      linux-headers \
      curl \
      unzip \
  && echo '@community http://dl-cdn.alpinelinux.org/alpine/v3.9/community' >> /etc/apk/repositories \
  && apk add --no-cache --update \
      php7@community \
      php7-dev@community \
      php7-bcmath@community \
      php7-dom@community \
      php7-common@community \
      php7-ctype@community \
      php7-cli@community \
      php7-curl@community \
      php7-fileinfo@community \
      php7-fpm@community \
      php7-gettext@community \
      php7-gd@community \
      php7-iconv@community \
      php7-json@community \
      php7-mbstring@community \
      php7-mcrypt@community \
      php7-mysqli@community \
      php7-mysqlnd@community \
      php7-opcache@community \
      php7-odbc@community \
      php7-pdo@community \
      php7-pdo_mysql@community \
      php7-pdo_pgsql@community \
      php7-pdo_sqlite@community \
      php7-phar@community \
      php7-posix@community \
      php7-redis@community \
      php7-session@community \
      php7-simplexml@community \
      php7-soap@community \
      php7-tokenizer@community \
      php7-xml@community \
      php7-xmlreader@community \
      php7-xmlwriter@community \
      php7-simplexml@community \
      php7-zip@community \
      php7-zlib@community \
      mysql-client\
      curl \
      monit \
      bash \
      xz \
      libressl \
      icu-libs \
      ca-certificates \
      libxml2-dev \
      tar \
  && mkdir -p /var/run \
  && mkdir -p ${LOG_PREFIX} \
  && rm -rf /tmp/* \
  && rm -rf /var/cache/apk/* \
  && touch ${LOG_PREFIX}/access.log \
  && touch ${LOG_PREFIX}/error.log \
  && ln -sf /dev/stdout ${LOG_PREFIX}/access.log \
  && ln -sf /dev/stderr ${LOG_PREFIX}/error.log

COPY conf/monit/ /etc/monit.d/
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY check_wwwdata.sh /usr/bin/check_wwwdata
COPY check_folder.sh /usr/bin/check_folder

EXPOSE 9000

RUN chmod +x /docker-entrypoint.sh /usr/bin/check_wwwdata /usr/bin/check_folder

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm7", "-g", "/var/run/php-fpm.pid"]
