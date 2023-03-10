FROM php:7.4
LABEL maintainers="Athanasios Ntavelis <davelis89@gmail.com>"

# Install composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install zip and unzip unix packages, required from composer
RUN apt update && apt install -y --no-install-recommends zip unzip && rm -rf /var/lib/apt/lists/*;

# Install Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug
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