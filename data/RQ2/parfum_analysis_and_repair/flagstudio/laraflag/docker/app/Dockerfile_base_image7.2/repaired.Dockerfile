ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm-alpine

#
#--------------------------------------------------------------------------
# Some ebala for PHP
#--------------------------------------------------------------------------
#


RUN apk --update --no-cache add wget \
#  apt-utils \
  curl \
  git \
  build-base \
  libmemcached-dev \
  libmcrypt-dev \
  libxml2-dev \
  zlib-dev \
  autoconf \
  cyrus-sasl-dev \
  libgsasl-dev \
  supervisor \
  libzip-dev \
  icu-dev \
#  zlib1g-dev \
#  libicu-dev \
  g++ \
#  libmagickwand-dev \
  imagemagick \
  # wkhtmltopdf
  xvfb \
  # Additionnal dependencies for better rendering
  ttf-freefont \
  fontconfig \
  dbus \
  bash \
  libpng \
  libpng-dev \
  libjpeg-turbo-dev \
  libwebp-dev zlib-dev \
  freetype-dev \

  libxpm-dev && \


# For wkhtmltopdf
    apk add qt5-qtbase-dev \
            wkhtmltopdf \
            --no-cache \
            --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ \
            --allow-untrusted \
    && \

    # Wrapper for xvfb
    mv /usr/bin/wkhtmltopdf /usr/bin/wkhtmltopdf-origin && \
    echo $'#!/usr/bin/env sh\n\
Xvfb :0 -screen 0 1024x768x24 -ac +extension GLX +render -noreset & \n\
DISPLAY=:0.0 wkhtmltopdf-origin $@ \n\
killall Xvfb\
' > /usr/bin/wkhtmltopdf && \
    chmod +x /usr/bin/wkhtmltopdf && \

    apk del libpng-dev libjpeg-turbo-dev libwebp-dev zlib-dev libxpm-dev

# For Imagick
RUN set -ex \
    && apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS imagemagick-dev libtool \
    && export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
    && pecl install imagick-3.4.3 \
    && docker-php-ext-enable imagick \
    && apk add --no-cache --virtual .imagick-runtime-deps imagemagick \
    && apk del .phpize-deps

RUN docker-php-ext-install mysqli mbstring pdo pdo_mysql tokenizer xml pcntl bcmath intl zip exif gd && \
    docker-php-ext-configure zip --with-libzip

# GD library

RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
        freetype \
        libpng \
        libjpeg-turbo \
        freetype-dev \
        libpng-dev \
        jpeg-dev \
        libjpeg \
        libjpeg-turbo-dev

RUN docker-php-ext-configure gd \
        --with-freetype-dir=/usr/lib/ \
        --with-png-dir=/usr/lib/ \
        --with-jpeg-dir=/usr/lib/ \
        --with-gd

RUN NUMPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
    && docker-php-ext-install -j${NUMPROC} gd

# Memcached

RUN pecl channel-update pecl.php.net && \
    pecl install memcached mcrypt-1.0.1 && \
    docker-php-ext-enable memcached

#
#--------------------------------------------------------------------------
# Some govno for Caddy web server
#--------------------------------------------------------------------------
#
ARG VERSION="0.10.11"

RUN apk update && apk upgrade \
  && apk add --no-cache openssh-client git \
  && apk add --no-cache --virtual .build-dependencies tar curl

RUN curl --silent --show-error --fail --location \
      --header "Accept: application/tar+gzip, application/x-gzip, application/octet-stream" -o - \
      "https://github.com/mholt/caddy/releases/download/v${VERSION}/caddy_v${VERSION}_linux_amd64.tar.gz" \
    | tar --no-same-owner -C /usr/bin -xz \
 && chmod 0755 /usr/bin/caddy \
 && /usr/bin/caddy -version \
 && apk del .build-dependencies



###########################################################################
# Composer
###########################################################################

USER root
RUN apk add --no-cache composer

ARG COMPOSER_REPO_PACKAGIST
ENV COMPOSER_REPO_PACKAGIST ${COMPOSER_REPO_PACKAGIST}

# Export composer vendor path
RUN echo "" >> ~/.bashrc && \
    echo 'export PATH="~/.composer/vendor/bin:$PATH"' >> ~/.bashrc
RUN composer global require hirak/prestissimo
# Nova CMS credentials
ARG NOVA_USERNAME
ARG NOVA_PASSWORD
RUN composer global config http-basic.nova.laravel.com ${NOVA_USERNAME} ${NOVA_PASSWORD}


###########################################################################
# NPM
###########################################################################

RUN apk add --no-cache python make automake autoconf
RUN apk add  --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/main/ nodejs=8.9.3-r1


# You need to install:
# configs for php, caddy, supervisor
# copy projects files inside image
# composer install (not as easy as it seems
# cache routes, configs, create storage link
# run endpoint
# expose ports
# So, you need flagstudio/laraflag:latest on gitlab resitry. Ask Misha for more info.
