FROM php:7.2-apache

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    default-mysql-client && rm -rf /var/lib/apt/lists/*;

COPY docker/laconia.serve /etc/apache2/sites-available/000-default.conf

# Install extensions
RUN docker-php-ext-install pdo_mysql

# Install Composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite

WORKDIR /var/www/laconia