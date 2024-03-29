#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/php-nginx:ubuntu-15.10
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/php:ubuntu-15.10

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""
ENV WEB_PHP_SOCKET=127.0.0.1:9000
ENV SERVICE_NGINX_CLIENT_MAX_BODY_SIZE="50m"

COPY conf/ /opt/docker/

RUN set -x \
    # Install nginx