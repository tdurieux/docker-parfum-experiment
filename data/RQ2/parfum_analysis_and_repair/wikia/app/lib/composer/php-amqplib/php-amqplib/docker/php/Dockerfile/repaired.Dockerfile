FROM php:5.4-cli

RUN apt update && \
    apt -qy --no-install-recommends install git unzip zlib1g-dev && \
    docker-php-ext-install bcmath sockets pcntl zip && rm -rf /var/lib/apt/lists/*;

WORKDIR /src
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer

