# PHP Version
ARG PHP_V
FROM php:${PHP_V}-fpm

# Node Version
ARG NODE_V

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl \
    libmemcached-dev \
    libz-dev \
    libjpeg-dev \
    libpng-dev \
    libwebp-dev \
    libssl-dev \
    libmcrypt-dev \
    python2 \
    less \
    nano \
    vim \
    cron \
    git \
    unzip \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev && rm -rf /var/lib/apt/lists/*;

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN apt-get install -y --no-install-recommends php-common || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install common || true
RUN apt-get install -y --no-install-recommends php-pear || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install pear && docker-php-ext-enable pear || true   
RUN apt-get install -y --no-install-recommends php-intl || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install intl && docker-php-ext-enable intl || true
RUN apt-get install -y --no-install-recommends php-opcache || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install opcache && docker-php-ext-enable opcache || true
RUN apt-get install -y --no-install-recommends php-pdo || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql || true
RUN apt-get install -y --no-install-recommends php-mbstring || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install mbstring && docker-php-ext-enable mbstring || true
RUN apt-get install -y --no-install-recommends php-zip || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install zip && docker-php-ext-enable zip || true
RUN apt-get install -y --no-install-recommends php-memcache || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install memcache && docker-php-ext-enable memcache || true
RUN apt-get install -y --no-install-recommends php-json || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install json && docker-php-ext-enable json || true
RUN apt-get install -y --no-install-recommends php-xml || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install xml && docker-php-ext-enable xml || true
RUN apt-get install -y --no-install-recommends php-exif || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install exif && docker-php-ext-enable exif || true
RUN apt-get install -y --no-install-recommends php-redis || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install redis && docker-php-ext-enable redis || true
RUN apt-get install -y --no-install-recommends php-bcmatch || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install bcmatch && docker-php-ext-enable bcmatch || true
RUN apt-get install -y --no-install-recommends php-ctype || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install ctype && docker-php-ext-enable ctype || true
RUN apt-get install -y --no-install-recommends php-curl || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install curl && docker-php-ext-enable curl || true
RUN apt-get update && apt-get install -y libmagickwand-dev --no-install-recommends && rm -rf /var/lib/apt/lists/* || true
RUN pecl install imagick || true
RUN docker-php-ext-enable imagick || true
RUN apk add --no-cache libpng libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev gd && docker-php-ext-install gd || true
RUN apt-get install -y --no-install-recommends php-gd || true && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install gd && docker-php-ext-enable gd || true
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp || true
RUN docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ --with-webp-dir=/usr/include/ || true
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    libzip-dev \
    libjpeg62-turbo-dev \
    libpng-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install gd

# Install composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install node & npm
RUN curl -f -sL https://deb.nodesource.com/setup_$NODE_V.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Add user
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# User aliases
RUN echo 'alias ll="ls -al"' >> /home/www/.bashrc
RUN echo 'alias ed="sh ed"' >> /home/www/.bashrc
RUN echo 'alias cd..="cd .."' >> /home/www/.bashrc
RUN echo 'alias art="php artisan"' >> /home/www/.bashrc
RUN echo 'alias migrate="php artisan migrate"' >> /home/www/.bashrc

# User permissions
RUN chown -R www:www /var/www

# Change current user to www
USER www

# Expose port 9000
EXPOSE 9000
CMD ["php-fpm"]
