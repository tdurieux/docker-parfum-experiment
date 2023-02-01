FROM php:8.1-fpm

RUN apt-get update && apt-get install --no-install-recommends -y \
    git \
    libzip-dev \
    unzip \
    zip && rm -rf /var/lib/apt/lists/*;

RUN curl -f --silent --show-error https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

CMD ["php", "cli/wss-server.php"]
