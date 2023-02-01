#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/nginx:debian-8
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/base:debian-8

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""
ENV SERVICE_NGINX_CLIENT_MAX_BODY_SIZE="50m"

COPY conf/ /opt/docker/

RUN set -x \
    # Install nginx
    && printf "deb http://nginx.org/packages/debian/ $(docker-image-info dist-codename)  nginx\n deb-src http://nginx.org/packages/debian/ $(docker-image-info dist-codename) nginx" \
    >> /etc/apt/sources.list \
    && curl -L https://nginx.org/keys/nginx_signing.key | apt-key add - \
    && apt-install \
    nginx \
    && docker-run-bootstrap \
    && docker-image-cleanup

EXPOSE 80 443
