FROM php:7.1-cli
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get --assume-yes --quiet update

RUN apt-get --assume-yes -y --no-install-recommends --quiet install git && \
    apt-get --assume-yes -y --no-install-recommends --quiet install libpng-dev && \
    apt-get --assume-yes -y --no-install-recommends --quiet install rsync && \
    apt-get --assume-yes -y --no-install-recommends --quiet install zip && rm -rf /var/lib/apt/lists/*;

RUN curl -f --silent --show-error "https://getcomposer.org/installer" | php && \
    mv "composer.phar" "/usr/local/bin/composer" && \
    composer global require --no-interaction "phpunit/phpunit"

RUN docker-php-ext-configure gd && \
    docker-php-ext-install gd

ENV PATH /root/.composer/vendor/bin:$PATH
CMD ["bash"]
