#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/apache:ubuntu-17.04
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/base:ubuntu-17.04

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""

COPY conf/ /opt/docker/

RUN set -x \
    # Install apache