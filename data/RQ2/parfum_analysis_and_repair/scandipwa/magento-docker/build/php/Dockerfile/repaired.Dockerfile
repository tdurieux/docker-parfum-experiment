FROM php:7.4-fpm

# Configure the gd library
RUN apt-get update; \
    apt-get install --no-install-recommends -y \
        git \
        build-essential \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        zlib1g-dev \
        g++ \
        libmcrypt-dev \
        libxslt1-dev \
        libsodium-dev \
        libargon2-0-dev \
        libjpeg62-turbo-dev \
        libonig-dev \
        libssl-dev \
        libzip-dev \
        libicu-dev; rm -rf /var/lib/apt/lists/*; \
    # First, try installing the old way, else switch to PHP 7.4 style
    ( \
        docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr --with-png-dir=/usr \
        || docker-php-ext-configure gd --with-freetype --with-jpeg; \
    ); \
    docker-php-ext-install -j$(nproc) \
        gd \
        intl \
        mbstring \
        pdo \
        pdo_mysql \
        phar \
        xsl \
        zip \
        bcmath \
        dom \
        soap \
        sockets

# Install NODEJS
RUN curl -f -sL https://deb.nodesource.com/setup_lts.x | bash -; \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install GOSU , SMTP and other packages
RUN apt-get install --no-install-recommends -y \
    gosu \
    bc \
    msmtp \
    msmtp-mta && rm -rf /var/lib/apt/lists/*;

# Install composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.17

# Install Magerun2 from n98
RUN curl -f -O https://files.magerun.net/n98-magerun2.phar; \
    chmod +x ./n98-magerun2.phar; \
    mv ./n98-magerun2.phar /usr/local/bin/n98-magerun2
