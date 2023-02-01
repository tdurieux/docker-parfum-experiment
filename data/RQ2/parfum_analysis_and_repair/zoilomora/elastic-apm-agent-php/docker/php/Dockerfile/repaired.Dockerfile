FROM php:5.4-cli

RUN apt update && \
    apt install --no-install-recommends -y \
        unzip && \
    docker-php-ext-install \
        mbstring && \
    pecl install xdebug-2.4.1 && \
    docker-php-ext-enable \
        xdebug && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

ENV PATH /var/app/bin:/var/app/vendor/bin:$PATH

WORKDIR /var/app
