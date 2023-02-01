FROM php:7.4-cli
# Install Composer
RUN apt-get update && apt-get install --no-install-recommends -y git zip unzip libzip-dev libicu-dev && docker-php-ext-configure intl && docker-php-ext-install intl zip && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY . /srv/
RUN cd srv && ls -l && composer install
RUN chmod +x /srv/entrypoint.sh
ENTRYPOINT ["/srv/entrypoint.sh"]
