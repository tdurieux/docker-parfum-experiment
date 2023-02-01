FROM shipito/php:7.0-alpine
MAINTAINER Patrik Votoček <patrik@votocek.cz>

ENV COMPOSER_DISABLE_XDEBUG_WARN 1

RUN apk --update --no-cache upgrade && \
    apk --update --no-cache add php7-xdebug --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/

CMD ["php", "-a"]
