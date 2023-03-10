FROM php:7.4
LABEL maintainers="Athanasios Ntavelis <davelis89@gmail.com>"

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    libzip-dev \
    curl \
    libonig-dev && rm -rf /var/lib/apt/lists/*;

# Install extensions
RUN docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl sockets bcmath

# Install composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug
#RUN echo 'xdebug.remote_host = "host.docker.internal"' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.default_enable = 1' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_port = 9000' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_autostart = 1' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_connect_back = 1' >> /usr/local/etc/php/php.ini
RUN echo 'xdebug.remote_enable = 1' >> /usr/local/etc/php/php.ini

# Add user for application
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory contents
COPY . /srv/app

# Copy existing application directory permissions
COPY --chown=www:www . /srv/app
