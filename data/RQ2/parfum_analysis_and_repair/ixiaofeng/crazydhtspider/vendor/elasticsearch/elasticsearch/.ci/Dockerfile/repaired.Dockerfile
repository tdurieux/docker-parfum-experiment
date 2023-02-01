ARG PHP_VERSION=7.4-cli
FROM php:${PHP_VERSION}

WORKDIR /usr/src/app

# Install git
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

# Install zip extension for PHP
RUN apt-get install --no-install-recommends -y \
        libzip-dev \
        zip \
        libyaml-dev \
    && docker-php-ext-install zip && rm -rf /var/lib/apt/lists/*;

# Install yaml extension for PHP
RUN pecl channel-update pecl.php.net
RUN pecl install yaml && docker-php-ext-enable yaml

# Print PHP version
RUN php -v

# Install composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Print composer version
RUN composer --version

COPY composer.json .

# Install dependencies with composer
RUN composer install

COPY . .

# Updating elasticsearch submodule
RUN git submodule update --init --recursive

CMD ["bash", ".ci/yaml-tests.sh"]