FROM php:7.4
RUN apt-get update \
    && apt-get install --no-install-recommends -y curl \
    && apt-get install --no-install-recommends -y libzip-dev \
    && docker-php-ext-install zip \
    && apt-get install --no-install-recommends -y libicu-dev \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install pdo_mysql \
    && apt-get install --no-install-recommends -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo_pgsql \
    && rm -rf /var/lib/apt/lists/* \
    && curl -f -L -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm /tmp/composer-setup.php \
    && curl -f -L -o /usr/local/bin/php-cs-fixer https://cs.sensiolabs.org/download/php-cs-fixer-v2.phar \
    && chmod a+x /usr/local/bin/php-cs-fixer
COPY . /code
WORKDIR /code
ENTRYPOINT ["tests/docker/php/entrypoint.sh"]
