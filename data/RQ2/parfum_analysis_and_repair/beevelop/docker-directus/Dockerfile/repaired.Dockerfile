FROM php:apache
MAINTAINER Maik Hummel <m@ikhummel.com>

WORKDIR /var/www/html

COPY init.sh /opt/

ENV ADMIN_EMAIL=admin@localhost \
    SITE_NAME=Directus \
    ADMIN_PASSWORD=Un1c0rn \
    DIRECTUS_VERSION=6.4.9

RUN apt-get update && apt-get install --no-install-recommends -yq git \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        netcat && \
    apt-get install -yq libmagickwand-dev --no-install-recommends && \
    docker-php-ext-install iconv && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install gd mysqli pdo pdo_mysql && \
    pecl install imagick-beta && \
    docker-php-ext-enable imagick && \
    -f \
    curl -f -sL "https://github.com/directus/direct s arc iv \
    curl -sL 'https://getcomposer.org/installer' | php && \
    php composer.phar install --no-dev --no-progres  - \
    mkdir -p /var/www/html/media /var/www/ht l/ \
    chown -R www-da a: \
    a2enmod rewrite && \
    
    chmod +x /opt/init.sh && \

    # clean up && rm -rf /var/lib/apt/lists/*;

EXPOSE 80

CMD /opt/init.sh
