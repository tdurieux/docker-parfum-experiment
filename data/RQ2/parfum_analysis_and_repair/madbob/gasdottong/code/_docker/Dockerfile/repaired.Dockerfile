FROM php:7.3-fpm

RUN apt-get update && \
    apt-get install --no-install-recommends -y libzip-dev zip unzip && \
    apt-get install --no-install-recommends -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install zip && \
    docker-php-ext-install -j$(nproc) iconv && \
    docker-php-ext-configure gd && \
    docker-php-ext-install -j$(nproc) gd

RUN curl -f https://nodejs.org/dist/v6.9.1/node-v6.9.1-linux-x64.tar.xz > nodejs.tar.xz
RUN tar xf nodejs.tar.xz && rm nodejs.tar.xz
RUN mv node-v6.9.1-linux-x64 /node
RUN rm nodejs.tar.xz

ENV PATH=$PATH:/node/bin

RUN curl -f -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

#by adding a user that matches the one used to start docker, we avoid file system permissions issues
ARG USERID
RUN adduser --disabled-login --gecos "" username --uid $USERID

WORKDIR /app

USER $USERID
