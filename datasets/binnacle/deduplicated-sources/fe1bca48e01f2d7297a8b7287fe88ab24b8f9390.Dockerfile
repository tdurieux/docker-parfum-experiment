FROM composer/composer:master-alpine
MAINTAINER Sandro Keil <docker@sandro-keil.de>

ENV VENDOR_PATH=/composer/vendor/

COPY composer.json /composer/

RUN composer global update

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
