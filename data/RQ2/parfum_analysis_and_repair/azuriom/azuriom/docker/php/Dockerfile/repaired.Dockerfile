FROM php:8.1-fpm

RUN apt-get update && apt-get install --no-install-recommends -y libicu-dev libzip-dev \
    libicu-dev zlib1g-dev libpng-dev libjpeg-dev libxml2-dev \
    libfreetype6-dev libmcrypt-dev libpng-dev libcurl3-dev libonig-dev && rm -rf /var/lib/apt/lists/*;

# Install Postgre PDO
RUN apt-get install --no-install-recommends -y libpq-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql pgsql zip && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean

RUN docker-php-ext-install intl opcache bcmath

COPY custom.ini $PHP_INI_DIR/conf.d/

WORKDIR /usr/share/nginx/html
