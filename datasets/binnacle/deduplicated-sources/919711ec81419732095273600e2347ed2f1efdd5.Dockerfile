FROM composer:1.8.5 AS composer
FROM php:7.2.13-fpm

# Let's use bash as a default shell
SHELL ["/bin/bash", "-c"]

# Update package list and install necessary libraries
RUN apt-get update && apt-get install -y \
    zlib1g-dev libxml2-dev nano vim git unzip jq bash-completion iproute \
    && rm -rf /var/lib/apt/lists/*

# Enable all necessary PHP packages
RUN docker-php-ext-install -j$(nproc) bcmath \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install zip \
    && pecl install xdebug-2.7.1 \
    && docker-php-ext-enable xdebug

# copy the Composer PHAR from the Composer image into the PHP image
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Allow use of composer as a root and add composer bin to path
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV PATH "$PATH:/root/.composer/vendor/bin"

# Define used work directory
WORKDIR /app

# Add everything inside docker image
ADD . .

# Install bamarni/symfony-console-autocomplete as a global one to get autocomplete working
RUN composer global require bamarni/symfony-console-autocomplete

RUN echo "xdebug.idekey = PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini  \
    && echo "xdebug.default_enable = 0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini  \
    && echo "xdebug.remote_enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini  \
    && echo "xdebug.remote_autostart = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini  \
    && echo "xdebug.remote_connect_back = 0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini  \
    && echo "xdebug.profiler_enable = 0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini  \
    && echo "xdebug.remote_host = 127.0.0.1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port = 9009" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Ensure that all required files has execute rights
RUN chmod +x /app/bin/console \
    && chmod +x /app/docker-entrypoint-dev.sh \
    && chmod +x /usr/bin/composer

# Allow to use more memory + add necessary stuff to bash autocomplete
RUN echo 'memory_limit = 2048M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini \
    && echo 'source /usr/share/bash-completion/bash_completion' >> /etc/bash.bashrc \
    && echo 'eval "$(symfony-autocomplete --shell bash)"' >> /etc/bash.bashrc

EXPOSE 9000

ENTRYPOINT ["/app/docker-entrypoint-dev.sh"]
