FROM php:7.4-fpm-buster

# Use the default production configuration
COPY contrib/docker/php.production.ini "$PHP_INI_DIR/php.ini"

# Install Composer
ENV COMPOSER_VERSION 1.9.2
ENV COMPOSER_HOME /var/www/.composer
RUN curl -f -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -f -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
  && php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && rm -rf /tmp/composer-setup.php

# Update OS Packages
RUN apt-get update

# Install OS Packages
RUN apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends \

      locales locales-all \
      git \
      gosu \
      zip \
      unzip \
      libzip-dev \
      libcurl4-openssl-dev \

      optipng \
      pngquant \
      jpegoptim \
      gifsicle \

      libjpeg62-turbo-dev \
      libpng-dev \

      libxpm4 \
      libxpm-dev \
      libwebp6 \
      libwebp-dev \

      ffmpeg && rm -rf /var/lib/apt/lists/*;

# Update Local data
RUN sed -i '/en_US/s/^#//g' /etc/locale.gen && locale-gen && update-locale

# Install PHP extensions
RUN docker-php-source extract

#PHP Imagemagick extensions
RUN apt-get install -y --no-install-recommends libmagickwand-dev && rm -rf /var/lib/apt/lists/*;
RUN pecl install imagick
RUN docker-php-ext-enable imagick

# PHP GD extensions
RUN docker-php-ext-configure gd \
      --with-freetype \
      --with-jpeg \
      --with-webp \
      --with-xpm
RUN docker-php-ext-install -j$(nproc) gd

#PHP Redis extensions
RUN pecl install redis
RUN docker-php-ext-enable redis

#PHP Database extensions
RUN apt-get install -y --no-install-recommends libpq-dev libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install pdo_mysql pdo_pgsql pdo_sqlite

#PHP extensions (dependencies)
RUN docker-php-ext-configure intl
RUN docker-php-ext-install -j$(nproc) intl bcmath zip pcntl exif curl

#Cleanup
RUN docker-php-source delete
RUN apt-get autoremove --purge -y
RUN rm -rf /var/cache/apt
RUN rm -rf /var/lib/apt/lists/*

ENV PATH="~/.composer/vendor/bin:./vendor/bin:${PATH}"

COPY . /var/www/
WORKDIR /var/www/

RUN cp -r storage storage.skel
RUN composer global require hirak/prestissimo --no-interaction --no-suggest --prefer-dist
RUN composer install --prefer-dist --no-interaction --no-ansi --optimize-autoloader
RUN composer global remove hirak/prestissimo
RUN rm -rf html && ln -s public html

VOLUME /var/www/storage /var/www/bootstrap

CMD ["/var/www/contrib/docker/start.fpm.sh"]
