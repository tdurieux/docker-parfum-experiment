#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/php-dev:centos-7-php7
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/php:centos-7-php7

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