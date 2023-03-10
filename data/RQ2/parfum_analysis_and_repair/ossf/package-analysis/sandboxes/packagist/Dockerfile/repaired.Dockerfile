FROM php:7.4-zts-bullseye AS image

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        curl \
        wget \
        git \
        unzip \
        libzip-dev \
        libpng-dev && rm -rf /var/lib/apt/lists/*;

RUN docker-php-ext-install zip && \
    docker-php-ext-install gd

COPY analyze.php /usr/local/bin/
RUN chmod 755 /usr/local/bin/analyze.php
RUN mkdir -p /app

FROM scratch
COPY --from=image / /
WORKDIR /app

ENTRYPOINT [ "sleep" ]

CMD [ "30m" ]