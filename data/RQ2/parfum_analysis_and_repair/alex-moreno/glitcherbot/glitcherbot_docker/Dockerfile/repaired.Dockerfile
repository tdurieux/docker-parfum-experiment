FROM php:7.4-apache

RUN a2enmod rewrite

RUN set -eux \
   && apt-get update \
   && apt-get install --no-install-recommends -y libzip-dev zlib1g-dev \
   && docker-php-ext-install zip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://getcomposer.org/composer-2.phar --output ~/composer-2.phar \
    && chmod +x ~/composer-2.phar \
    && mv ~/composer-2.phar /usr/local/bin/composer \
    && composer --version
