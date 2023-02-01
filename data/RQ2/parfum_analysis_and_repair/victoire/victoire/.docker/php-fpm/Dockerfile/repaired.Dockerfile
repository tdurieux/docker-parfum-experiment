FROM phpdockerio/php71-fpm:latest

# Install selected extensions and other stuff
RUN apt-get update \
    && curl -f -sL https://deb.nodesource.com/setup_4.x | bash - \
    && apt-get -y --no-install-recommends install php7.1-mysql php7.1-redis php7.1-xdebug nodejs \
    && npm install -g less@2.7.2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* && npm cache clean --force;

WORKDIR "/var/www/victoire"
