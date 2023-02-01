FROM php:8.1-fpm

RUN docker-php-ext-install pdo_mysql

RUN apt-get update \
    && apt-get install --no-install-recommends -y sudo \
    && apt-get install --no-install-recommends -y \
        curl \
        sed \
        zlib1g-dev \
        git \
        zip \
        unzip \
        nano \
        openssl \
        libssl-dev \
        libcurl4-openssl-dev \
        libxml2-dev \
    && apt-get clean -y \
    && docker-php-ext-install soap \
    && apt-get install --no-install-recommends -y zip libzip-dev \
    && docker-php-ext-install zip \
    && apt-get install --no-install-recommends -y supervisor && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y cron && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql
RUN docker-php-ext-install pdo pdo_pgsql
RUN pecl install mongodb
RUN echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini
RUN docker-php-ext-configure intl && docker-php-ext-install intl
RUN cd ~
RUN sudo curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN docker-php-ext-install sockets
RUN apt-get install --no-install-recommends -y libgmp-dev re2c libmhash-dev libmcrypt-dev file && rm -rf /var/lib/apt/lists/*;
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/local/include/
RUN docker-php-ext-configure gmp
RUN docker-php-ext-install gmp
RUN echo "extension=gmp.so" >> /usr/local/etc/php/conf.d/gmp.ini
RUN docker-php-ext-install bcmath
RUN echo 'cd /var/www/html/app' >> ~/.bashrc
