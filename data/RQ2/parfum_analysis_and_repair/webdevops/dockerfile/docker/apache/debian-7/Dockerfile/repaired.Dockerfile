#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/apache:debian-7
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/base:debian-7

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""

COPY conf/ /opt/docker/

RUN set -x \
    # Install apache