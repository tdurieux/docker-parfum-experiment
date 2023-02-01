FROM php:8.0
MAINTAINER Timur Shagiakhmetov <timur.shagiakhmetov@corp.badoo.com>

RUN apt-get update && apt-get -y --no-install-recommends install git-core unzip \
&& pecl install xdebug \
&& echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
&& curl -f --silent --show-error https://getcomposer.org/installer | php \
&& mv composer.phar /usr/local/bin/composer && rm -rf /var/lib/apt/lists/*;

# mysql extension
RUN docker-php-ext-install -j$(nproc) mysqli pdo_mysql

# postgresql extension
RUN apt-get -y --no-install-recommends install libpq-dev \
&& docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
&& docker-php-ext-install -j$(nproc) pgsql pdo_pgsql && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
