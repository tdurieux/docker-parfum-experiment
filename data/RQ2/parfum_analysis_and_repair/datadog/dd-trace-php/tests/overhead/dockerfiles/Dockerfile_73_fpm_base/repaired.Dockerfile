FROM php:7.3-fpm

RUN apt update \
    && apt install --no-install-recommends -y \
    libfcgi0ldbl \
    gdb \
    git \
    less \
    libcurl4-gnutls-dev \
    libfcgi0ldbl \
    multitime \
    procps \
    sudo \
    time \
    unzip \
    wget \
    vim \
    && pecl install xdebug \
    && docker-php-ext-install opcache \
    && rm -rf /var/lib/apt/lists/*

# Install composer
ADD ./tests/overhead/dockerfiles/composer-installer.php composer-installer.php
RUN php composer-installer.php  --install-dir="/usr/bin" --filename=composer \
    && php -r "unlink('composer-installer.php');"

RUN mkdir -p /var/log/php-fpm
RUN chmod -R a+w /var/log/php-fpm

ADD ./tests/overhead/dockerfiles/www.conf /usr/local/etc/php-fpm.d/www.conf
ADD ./tests/overhead/dockerfiles/php-fpm.conf /usr/local/etc/php-fpm.conf
ADD ./tests/overhead/dockerfiles/99-ddtrace-custom.ini /usr/local/etc/php/conf.d/99-ddtrace-custom.ini
ADD ./tests/overhead/dockerfiles/opcache.ini /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini
ADD ./tests/overhead/dockerfiles/xdebug.ini /usr/local/etc/php/conf.d-available/xdebug.ini

ENV DD_AGENT_HOST=agent

ADD ./tests/overhead/dockerfiles/start_app.sh /start_app.sh
CMD [ "/start_app.sh" ]

RUN mkdir -p /tmp/php-cache
RUN chmod -R 777 /tmp/php-cache

RUN mkdir -p /var/www/public
WORKDIR /var/www
ADD ./tests/overhead/Laravel57 /var/www
RUN composer update

RUN mkdir -p /dd-trace-php
WORKDIR /dd-trace-php
