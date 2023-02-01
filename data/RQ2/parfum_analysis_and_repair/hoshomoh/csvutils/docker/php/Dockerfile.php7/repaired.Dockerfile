FROM php:7.4-fpm

ENV APP_DIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    curl \
    zip \
    unzip && rm -rf /var/lib/apt/lists/*;

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR $APP_DIR

# Add the start script and change the permissions
COPY ./docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

CMD /docker-entrypoint.sh
