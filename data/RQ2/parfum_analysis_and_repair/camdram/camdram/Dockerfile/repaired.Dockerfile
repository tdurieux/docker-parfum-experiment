FROM php:7.3-cli

WORKDIR /usr/src/camdram

RUN apt-get update && \
    apt-get install --no-install-recommends -y git zip unzip curl wget nano vim python3 && \
    docker-php-ext-install -j$(nproc) pdo pdo_mysql && \
    wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet && \
    mv composer.phar /usr/local/bin/composer && \
    apt-get -q clean && \
    rm -rf /var/lib/apt/lists && \
    sed -e "s/memory_limit = 128M/memory_limit = 1G/" "$PHP_INI_DIR/php.ini-development" > "$PHP_INI_DIR/php.ini" && rm -rf /var/lib/apt/lists/*;

CMD ["/usr/src/camdram/docker-entrypoint.sh"]
