FROM php:7.3-apache

ARG COMPOSER_VERSION="1.8.5"
ARG COMPOSER_CHECKSUM="4e4c1cd74b54a26618699f3190e6f5fc63bb308b13fa660f71f2a2df047c0e17"

RUN apt-get update \
 && apt-get install -y --no-install-recommends apt-utils \
 && apt-get install -y --no-install-recommends git gosu \
      optipng pngquant jpegoptim gifsicle libpq-dev libsqlite3-dev locales zip unzip libzip-dev libcurl4-openssl-dev \
      libfreetype6 libicu-dev libjpeg62-turbo libpng16-16 libxpm4 libwebp6 libmagickwand-6.q16-3 \
      libfreetype6-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libwebp-dev libmagickwand-dev \
 && sed -i '/en_US/s/^#//g' /etc/locale.gen \
 && locale-gen && update-locale \
 && docker-php-source extract \
 && docker-php-ext-configure gd \
      --with-freetype-dir=/usr/lib/x86_64-linux-gnu/ \
      --with-jpeg-dir=/usr/lib/x86_64-linux-gnu/ \
      --with-xpm-dir=/usr/lib/x86_64-linux-gnu/ \
      --with-webp-dir=/usr/lib/x86_64-linux-gnu/ \
 && docker-php-ext-install pdo_mysql pdo_pgsql pdo_sqlite pcntl gd exif bcmath intl zip curl \
 && pecl install imagick \
 && docker-php-ext-enable imagick pcntl imagick gd exif zip curl \
 && a2enmod rewrite remoteip \
 && {\
     echo RemoteIPHeader X-Real-IP ;\
     echo RemoteIPTrustedProxy 10.0.0.0/8 ;\
     echo RemoteIPTrustedProxy 172.16.0.0/12 ;\
     echo RemoteIPTrustedProxy 192.168.0.0/16 ;\
     echo SetEnvIf X-Forwarded-Proto "https" HTTPS=on ;\
    } > /etc/apache2/conf-available/remoteip.conf \
 && a2enconf remoteip \
 && curl -LsS https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar -o /usr/bin/composer \
 && echo "${COMPOSER_CHECKSUM}  /usr/bin/composer" | sha256sum -c - \
 && chmod 755 /usr/bin/composer \
 && apt-get autoremove --purge -y \
       libfreetype6-dev libjpeg62-turbo-dev libpng-dev libxpm-dev libvpx-dev libmagickwand-dev \
 && rm -rf /var/cache/apt \
 && docker-php-source delete

ENV PATH="~/.composer/vendor/bin:./vendor/bin:${PATH}"

COPY . /var/www/

WORKDIR /var/www/
RUN cp -r storage storage.skel \
 && cp contrib/docker/php.ini /usr/local/etc/php/conf.d/pixelfed.ini \
 && composer install --prefer-source --no-interaction \
 && rm -rf html && ln -s public html

VOLUME /var/www/storage /var/www/bootstrap

ENV APP_ENV=production \
    APP_DEBUG=false \
    LOG_CHANNEL=stderr \
    DB_CONNECTION=mysql \
    DB_PORT=3306 \
    DB_HOST=db \
    BROADCAST_DRIVER=log \
    QUEUE_DRIVER=redis \
    HORIZON_PREFIX=horizon-pixelfed \
    REDIS_HOST=redis \
    SESSION_SECURE_COOKIE=true \
    API_BASE="/api/1/" \
    API_SEARCH="/api/search" \
    OPEN_REGISTRATION=true \
    ENFORCE_EMAIL_VERIFICATION=true \
    REMOTE_FOLLOW=false \
    ACTIVITY_PUB=false

CMD /var/www/contrib/docker/start.sh
