FROM php:7.4-fpm

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

WORKDIR /usr/limelight

# Install apt dependencies
RUN apt-get update && apt-get install --no-install-recommends -y less curl cron wget git libzip-dev mecab mecab-ipadic-utf8 mecab-utils libmecab-dev unzip build-essential && rm -rf /var/lib/apt/lists/*;

# Setup PHP
RUN docker-php-ext-install pdo_mysql zip

RUN wget https://github.com/nihongodera/php-mecab/archive/master.zip \
    && unzip master.zip \
    && cd php-mecab-master/mecab \
    && phpize \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && docker-php-ext-enable mecab

COPY ./docker/install_composer.sh /tmp/install_composer.sh
RUN /tmp/install_composer.sh
