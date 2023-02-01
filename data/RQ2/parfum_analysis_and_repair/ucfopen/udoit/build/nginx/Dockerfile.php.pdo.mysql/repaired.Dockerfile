FROM php:8.1-fpm

# PHP extensions
RUN apt-get update && apt-get install --no-install-recommends -y libpng-dev zlib1g-dev git unzip && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install gd pdo pdo_mysql