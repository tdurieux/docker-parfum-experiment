FROM php:5.6-apache

WORKDIR /var/www/html

COPY ./default.conf /etc/apache2/sites-available/000-default.conf

RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get update && apt-get install -y libmcrypt-dev libpng-dev libzip-dev zip unzip \
    mysql-client libmagickwand-dev --no-install-recommends \
    && docker-php-ext-configure zip --with-libzip \
    && docker-php-ext-install zip \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-ext-install mcrypt gd && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
  apt-get -y --no-install-recommends install curl git libicu-dev libpq-dev zlib1g-dev && \
  docker-php-ext-install intl mbstring pcntl pdo_mysql pdo_pgsql && \
  usermod -u 1000 www-data && \
  usermod -a -G users www-data && \
  chown -R www-data:www-data /var/www && \
  curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
  a2enmod rewrite && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
    libfreetype6-dev libjpeg62-turbo-dev \
    libgd-dev libpng-dev && rm -rf /var/lib/apt/lists/*;
    RUN docker-php-ext-configure gd \ 
    --with-freetype-dir=/usr/include/ \ 
    --with-jpeg-dir=/usr/include/
    RUN docker-php-ext-install gd

COPY . /var/www/html

RUN composer install