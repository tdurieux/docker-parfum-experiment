#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/nginx:centos-7
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/base:centos-7

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""
ENV SERVICE_NGINX_CLIENT_MAX_BODY_SIZE="50m"

COPY conf/ /opt/docker/

RUN set -x \
    # Install tools