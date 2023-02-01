ARG PHP_VERSION=8.0-cli
FROM php:${PHP_VERSION}

WORKDIR /usr/src/app

# Install git
RUN apt-get update -qq > /dev/null && \
    apt-get install -y --no-install-recommends git -qq > /dev/null && rm -rf /var/lib/apt/lists/*;

# Install zip extension for PHP
RUN apt-get install --no-install-recommends -y \
        libzip-dev \
        zip \
        libyaml-dev \
        -qq > /dev/null \
    && docker-php-ext-install zip > /dev/null && rm -rf /var/lib/apt/lists/*;

# Install yaml extension for PHP
RUN pecl channel-update pecl.php.net > /dev/null
RUN pecl install yaml > /dev/null
RUN docker-php-ext-enable yaml > /dev/null

# Print PHP version
RUN php -v

# Install composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Print composer version
RUN composer --version

COPY composer.json .

# Install dependencies with composer
RUN composer install --no-progress > /dev/null

COPY . .

CMD ["bash", ".ci/yaml-tests.sh"]