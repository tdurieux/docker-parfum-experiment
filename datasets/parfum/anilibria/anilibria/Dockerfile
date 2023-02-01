FROM php:7.3.31-fpm-alpine3.13

USER root
WORKDIR /var/www/html

# Use the default development configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install required dependencies
RUN  \
    apk --update add \
        mc \
        git \
        nano \
        nginx \
        libzip-dev \
        libxml2-dev \
        supervisor \
        mysql-client && \
    docker-php-ext-install -j$(nproc) \
        zip \
        xml \
        exif \
        bcmath \
        pdo_mysql


RUN \
    apk add $PHPIZE_DEPS && \
    pecl install -o -f redis && \
    rm -rf /tmp/pear && \
    docker-php-ext-enable redis


ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions \
        imagick

# Copy source code
COPY . .

# Copy supervisor config
COPY .docker/configs/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

# Copy nginx configurations
RUN mkdir -p /run/nginx
COPY .docker/configs/nginx/conf.d /etc/nginx/conf.d
COPY .docker/configs/nginx/nginx.conf /etc/nginx/nginx.conf
COPY .docker/configs/php-fpm/zz-custom-docker.conf /usr/local/etc/php-fpm.d/

# Cron
RUN crontab .docker/configs/cron/crontab

# Start supervisor
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]