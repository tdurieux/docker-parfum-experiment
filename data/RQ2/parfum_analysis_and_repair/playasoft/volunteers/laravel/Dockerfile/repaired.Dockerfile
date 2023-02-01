FROM php:7.1.3-fpm

# Move files over
COPY composer.lock composer.json /var/www/

# Set working directory
WORKDIR /var/www

RUN apt-get update && apt-get install -y libmcrypt-dev git zip unzip apt-utils\
    mysql-client libmagickwand-dev --no-install-recommends \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install mcrypt pdo_mysql mbstring dom zip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Add user for laravel application
RUN groupadd -g 1000 homestead
RUN useradd -u 1000 -ms /bin/bash -g homestead homestead

# You're awesome. Just own it
COPY . /var/www
RUN chown -R homestead:homestead /var/www

# Set up composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.16
RUN composer install

# Make sure we have access
RUN mkdir -p /usr/lib/node_modules
RUN chown -R homestead:homestead /usr/lib/node_modules
COPY resources/js/config.example.js resources/js/config.js

# Do our dirty work
RUN npm install && npm cache clean --force;
RUN npm run build

USER homestead

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
