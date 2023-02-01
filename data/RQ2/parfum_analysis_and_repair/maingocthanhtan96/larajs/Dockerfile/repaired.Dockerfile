# Set the base image for subsequent instructions
FROM php:7.3

# Update packages
RUN apt-get update && apt-get install -y --no-install-recommends -qq git curl libmcrypt-dev libjpeg-dev libpng-dev libfreetype6-dev libbz2-dev && rm -rf /var/lib/apt/lists/*; # Install PHP and composer dependencies


# Clear out the local repository of retrieved package files
RUN apt-get clean

# Install needed extensions
# Here you can install any other extension that you need during the test and deployment process
RUN docker-php-ext-install pdo_mysql

# Install Composer
RUN curl -f --silent --show-error https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel Envoy
RUN composer global require "laravel/envoy=~1.0"
