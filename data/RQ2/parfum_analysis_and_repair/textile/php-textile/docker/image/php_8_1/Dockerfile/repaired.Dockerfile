FROM php:8.1-cli

RUN apt-get update && apt-get install --no-install-recommends -y \
    bash \
    git \
    libz-dev \
    zip \
    wget && rm -rf /var/lib/apt/lists/*;

RUN pecl install xdebug

RUN docker-php-ext-enable xdebug

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /app
