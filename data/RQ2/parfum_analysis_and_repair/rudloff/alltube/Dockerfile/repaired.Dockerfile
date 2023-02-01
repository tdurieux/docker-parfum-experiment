FROM php:7.3-apache
RUN apt-get update && apt-get install --no-install-recommends -y libicu-dev xz-utils git python libgmp-dev unzip ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install intl
RUN docker-php-ext-install gmp
RUN a2enmod rewrite
RUN curl -f -sS https://getcomposer.org/installer | php -- --quiet
COPY resources/php.ini /usr/local/etc/php/
COPY . /var/www/html/
RUN php composer.phar check-platform-reqs --no-dev
RUN php composer.phar install --prefer-dist --no-progress --no-dev --optimize-autoloader
ENV CONVERT=1
