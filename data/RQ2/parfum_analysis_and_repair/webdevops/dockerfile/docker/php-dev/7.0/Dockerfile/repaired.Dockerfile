#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/php-dev:7.0
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/php:7.0

COPY conf/ /opt/docker/

RUN set -x \
    # Install development environment
    && wget -q -O - https://packages.blackfire.io/gpg.key | apt-key add - \
    && echo "deb https://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list \
    && apt-install \
        blackfire-php \
        blackfire-agent \
    && pecl install xdebug-2.8.1 \
    && docker-php-ext-enable xdebug \
    # Enable php development services