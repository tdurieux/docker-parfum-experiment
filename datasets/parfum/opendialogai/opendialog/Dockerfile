FROM php:7.4-fpm

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
    apt-get update --allow-releaseinfo-change && apt-get install -y \
    nodejs \
    build-essential \
    zlib1g-dev \
    libicu-dev  \
    g++ \
    mariadb-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    libonig-dev \
    vim \
    unzip \
    git \
    curl \
    nginx && \
    npm install -g npm && \
    /etc/init.d/nginx start

# Install extensions
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl intl
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Copy existing application directory contents
COPY --chown=www-data:www-data . /var/www

# Copy the nginx conf file
RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/sites-available/default

COPY --chown=www-data:www-data docker/nginx-conf/docker-app.conf /etc/nginx/sites-available

RUN ln -s /etc/nginx/sites-available/docker-app.conf /etc/nginx/sites-enabled/docker-app.conf

RUN chown -R www-data:www-data /var/www

RUN chmod +x ./docker/scripts/docker-set-up.sh
RUN ./docker/scripts/docker-set-up.sh

RUN chmod -R 755 /var/www/storage

COPY docker/.env.example.docker .env

# Expose port 9000 and start php-fpm server
EXPOSE 9000
EXPOSE 80
EXPOSE 443

RUN ["chmod", "+x", "./docker/scripts/docker-start.sh"]
CMD ["./docker/scripts/docker-start.sh"]
