FROM php:8.1-fpm

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y nginx libpng-dev zlib1g-dev git unzip && rm -rf /var/lib/apt/lists/*;

# PHP_CPPFLAGS are used by the docker-php-ext-* scripts
ENV PHP_CPPFLAGS="$PHP_CPPFLAGS -std=c++11"

RUN docker-php-ext-install pdo_mysql gd pdo \
    && docker-php-ext-install opcache \
    && apt-get install --no-install-recommends libicu-dev -y \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && apt-get remove libicu-dev icu-devtools -y && rm -rf /var/lib/apt/lists/*;

RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
    } > /usr/local/etc/php/conf.d/php-opocache-cfg.ini


COPY ./build/nginx/deploy.conf /etc/nginx/sites-enabled/default

COPY ./build/nginx/entrypoint.sh /etc/entrypoint.sh
RUN chmod +x /etc/entrypoint.sh

COPY --chown=www-data:www-data . /var/www/html
RUN chown -R www-data:www-data /var/lib/nginx
WORKDIR /var/www/html

EXPOSE 80
ENTRYPOINT ["/etc/entrypoint.sh"]
