FROM php:7-cli

RUN apt-get -qq update && apt-get -qq install -y libmcrypt-dev zip zlib1g-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install mcrypt zip

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

ENV COMPOSER_HOME /usr/local/composer
WORKDIR /project
RUN composer global require "laravel/installer"
ENV PATH=$PATH:/usr/local/composer/vendor/bin
RUN chmod a+rwx /usr/local/composer -R
