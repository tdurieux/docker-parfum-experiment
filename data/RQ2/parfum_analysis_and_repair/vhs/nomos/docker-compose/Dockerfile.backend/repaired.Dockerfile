FROM php:7-fpm

ENV DEBIAN_FRONTEND=noninteractive

ENTRYPOINT [ "docker_compose_run.sh" ]
CMD ["php-fpm"]

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    git libzip-dev mariadb-client zip && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install -j$(nproc) bcmath mysqli zip

COPY ["composer.json", "/var/www/html/"]
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN /usr/bin/composer install

COPY ["app", "app"]
COPY ["vhs", "vhs"]
COPY ["migrations", "migrations"]
COPY ["tools", "tools"]
COPY ["docker", "/usr/bin"]
COPY ["conf/config.ini.php.docker", "/var/www/html/conf/config.ini.php"]

RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
