FROM php:7.4-fpm

WORKDIR /var/www

# Install bash
RUN apt-get update && apt-get install --no-install-recommends -y \
 bash-completion \
 zip \
 unzip && rm -rf /var/lib/apt/lists/*;

# Install Composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN chown -R www-data:www-data /var/www
