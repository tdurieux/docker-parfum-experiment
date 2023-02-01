FROM    php:7.3-apache
RUN apt-get update \
        && apt-get install --no-install-recommends -y libicu-dev \
        && docker-php-ext-configure intl \
        && docker-php-ext-install intl \
        && docker-php-ext-install gettext && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y locales-all && rm -rf /var/lib/apt/lists/*;
COPY    php.ini /usr/local/etc/php/conf.d/php.ini
COPY    translations /var/www/translations/
COPY    www/ /var/www/html/
COPY    on-init /pwinit/
