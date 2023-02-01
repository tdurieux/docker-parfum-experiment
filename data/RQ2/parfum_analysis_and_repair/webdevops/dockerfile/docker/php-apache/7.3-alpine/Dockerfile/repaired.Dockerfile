#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/php-apache:7.3-alpine
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/php:7.3-alpine

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""
ENV WEB_PHP_SOCKET=127.0.0.1:9000

COPY conf/ /opt/docker/

RUN set -x \
    # Install apache
    && apk-install \
        apache2 \
        apache2-ctl \
        apache2-utils \
        apache2-proxy \
        apache2-ssl \
    # Fix issue with module loading order of lbmethod_* (see https://serverfault.com/questions/922573/apache2-fails-to-start-after-recent-update-to-2-4-34-no-clue-why)