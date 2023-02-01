FROM php:8.0-fpm

RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# Install xsltproc for pslm html reports https://github.com/Roave/psalm-html-output
RUN apt-get update && apt-get install --no-install-recommends -y xsltproc && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
        libzip-dev \
        zip \
  && docker-php-ext-install zip && rm -rf /var/lib/apt/lists/*;

COPY ./php.ini /usr/local/etc/php/

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN usermod -u 1000 www-data

WORKDIR /var/www

EXPOSE 9000
