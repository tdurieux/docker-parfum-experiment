FROM php:7.1-fpm

# System dependencies
RUN apt-get update
RUN apt-get install --no-install-recommends -y git zlib1g-dev wget && rm -rf /var/lib/apt/lists/*;

# PHP Extensions
RUN docker-php-ext-install zip

# NodeJS
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash - && \
  apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Gulp
RUN npm install -g gulp && npm cache clean --force;

WORKDIR /var/vhosts/framework.zend.com
