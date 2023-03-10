# Docker file for Saito 5

# Apache Webserver with PHP
FROM php:7.2-apache

 #install all the system dependencies and enable PHP modules
RUN apt-get update && apt-get install --no-install-recommends -y \
      gettext \
      libgd-dev \

      libicu-dev \
      libpq-dev \
      libmcrypt-dev \
      mariadb-client \
      git \
      zlib1g-dev \
      libzip-dev \
      unzip \

      chromium && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install \
      gd \
      exif \
      intl \
      mbstring \
      pcntl \
      pdo_mysql \
#      pdo_pgsql \
#      pgsql \
      zip \
      opcache

# Install apcu
RUN pecl install apcu-5.1.18
RUN docker-php-ext-enable apcu
RUN echo "apc.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini

# Install xdebug
RUN pecl install xdebug-2.7.1
RUN docker-php-ext-enable xdebug
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
      && echo "xdebug.default_enable=1"  >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
      && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
      && echo "xdebug.remote_autostart=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
      && echo "xdebug.profiler_enable_trigger=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
      && echo "xdebug.profiler_output_dir=/var/www/html/tmp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Configure and install GD
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

#install composer
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

#install phing to global because of conflicts with other modules in app
RUN composer global require phing/phing
RUN echo "export PATH=~/.composer/vendor/bin:$PATH" >> ~/.bashrc

#set our application folder as an environment variable
ENV APP_HOME /var/www/html

#change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

#change the web_root to cakephp /var/www/html/webroot folder
# RUN sed -i -e "s/html/html\/app\/webroot/g" /etc/apache2/sites-enabled/000-default.conf

#change the web_root to cakephp /var/www/html/webroot folder
RUN echo "memory_limit=256M" >> /usr/local/etc/php/conf.d/memory_limit.ini
RUN echo "upload_max_filesize=20M" >> /usr/local/etc/php/conf.d/memory_limit.ini

# enable apache module rewrite
RUN a2enmod rewrite

# Install Nodejs
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn grunt-cli && npm cache clean --force;

#copy source files and run composer
COPY . $APP_HOME

#change ownership of our applications
RUN chown -R www-data:www-data $APP_HOME
