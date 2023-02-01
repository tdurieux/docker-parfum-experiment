FROM php:8.0-cli
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libzip-dev \
        zip \
        unzip \
        git \
        wget \
    && docker-php-ext-install -j$(nproc) gd sockets bcmath \
    && pecl install ds pcov \
    && docker-php-ext-enable ds \
    && wget https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 \
    && mv test-reporter-latest-linux-amd64 /usr/bin/cc-test-reporter  \
    && chmod +x /usr/bin/cc-test-reporter

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /opt/project

COPY composer.json composer.loc[k] phpunit.xml.dist psalm.xml Neo4jBundle.php ./
COPY Collector/ Collector/
COPY DependencyInjection/ DependencyInjection/
COPY EventSubscriber/ EventSubscriber/
COPY Factory/ Factory/
COPY Resources/ Resources/
COPY Tests/ Tests/


RUN composer install


