#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/php-nginx-dev:centos-7-php7
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/php-nginx:centos-7-php7

ENV WEB_DOCUMENT_ROOT=/app \
    WEB_DOCUMENT_INDEX=index.php \
    WEB_ALIAS_DOMAIN=*.vm \
    WEB_PHP_TIMEOUT=600 \
    WEB_PHP_SOCKET=""
ENV WEB_PHP_SOCKET=127.0.0.1:9000
ENV WEB_NO_CACHE_PATTERN="\.(css|js|gif|png|jpg|svg|json|xml)$"

COPY conf/ /opt/docker/

RUN set -x \
    && wget -O - "https://packages.blackfire.io/fedora/blackfire.repo" | tee /etc/yum.repos.d/blackfire.repo \
    && yum-install \
        # Install tools
        graphviz \
        # Install php development stuff
        php70w-pecl-xdebug \
        blackfire-php \
        blackfire-agent \
        # Tools
        nano \
        vim \
    # Enable php development services