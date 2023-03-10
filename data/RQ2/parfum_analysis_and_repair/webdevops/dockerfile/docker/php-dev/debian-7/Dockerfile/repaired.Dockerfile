#+++++++++++++++++++++++++++++++++++++++
# Dockerfile for webdevops/php-dev:debian-7
#    -- automatically generated  --
#+++++++++++++++++++++++++++++++++++++++

FROM webdevops/php:debian-7

COPY conf/ /opt/docker/

RUN set -x \
    # Install development environment
    && apt-install \
        gnupg \
    && wget -q -O - https://packages.blackfire.io/gpg.key | apt-key add - \
    && echo "deb https://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list \
    && apt-install \
        # Install tools
        graphviz \
        # Install php development stuff
        php5-xdebug \
        blackfire-php \
        blackfire-agent \
        # Tools
        nano \
        vim \
    # Enable php development services