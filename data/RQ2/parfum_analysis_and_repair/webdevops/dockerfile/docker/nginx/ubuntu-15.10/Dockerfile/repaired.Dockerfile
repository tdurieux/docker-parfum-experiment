#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/nginx:ubuntu-15.10
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/base:ubuntu-15.10

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""
ENV SERVICE_NGINX_CLIENT_MAX_BODY_SIZE="50m"

COPY conf/ /opt/docker/

RUN set -x \
    # Install nginx