FROM php:7.4-cli
RUN apt-get update && apt-get install --no-install-recommends -y libuv1-dev libevent-dev libssl-dev git libzip-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install zip
RUN pecl install channel://pecl.php.net/uv-0.2.4
RUN docker-php-ext-enable uv
RUN docker-php-ext-install sockets
RUN pecl install event
RUN docker-php-ext-enable event
RUN pecl install ev
RUN docker-php-ext-enable ev

RUN mkdir ~/lib && \
    cd ~/lib && \
    git clone https://github.com/expressif/pecl-event-libevent.git && \
    cd pecl-event-libevent && \
    phpize && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make && \
    make install

RUN docker-php-ext-enable libevent

WORKDIR /var/www/project

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY composer.json ./composer.json
COPY composer.lock ./composer.lock
COPY src ./src
COPY tests ./tests
COPY phpunit.xml ./phpunit.xml

RUN composer install

COPY demo ./demo