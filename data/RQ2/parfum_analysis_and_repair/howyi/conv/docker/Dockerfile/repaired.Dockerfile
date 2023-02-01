FROM php:7.3
RUN yes "" | pecl install xdebug && docker-php-ext-enable xdebug
RUN apt-get update && apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install pdo_mysql