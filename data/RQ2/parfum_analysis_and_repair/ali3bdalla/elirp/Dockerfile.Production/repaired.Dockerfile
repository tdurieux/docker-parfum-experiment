FROM php:8.0-fpm
RUN apt-get update -y && apt-get install --no-install-recommends -y openssl zip unzip git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -yqq curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apt-get install --no-install-recommends -yqq libpq-dev libcurl4-gnutls-dev libicu-dev zlib1g-dev libpng-dev libxml2-dev libzip-dev libbz2-dev && rm -rf /var/lib/apt/lists/*;
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install curl
# RUN docker-php-ext-install json
RUN docker-php-ext-install intl
RUN docker-php-ext-install gd
RUN docker-php-ext-install xml
RUN docker-php-ext-install  zip
RUN docker-php-ext-install bz2 opcache bcmath ctype
RUN docker-php-ext-install pcntl
RUN pecl install swoole
RUN docker-php-ext-enable swoole
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
# Install Node
RUN apt-get install --no-install-recommends -yqq nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -yqq supervisor && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -yqq nano && rm -rf /var/lib/apt/lists/*;
COPY ./scripts/memory-limit-php.ini /usr/local/etc/php/conf.d/memory-limit-php.ini
COPY ./scripts/supervisor-prod.conf /etc/supervisor/conf.d/app.conf

WORKDIR /var/www/html
COPY . .
RUN composer install --prefer-dist --no-dev
RUN cp .env.example .env

RUN echo 'npm install'
RUN npm install && npm cache clean --force;

RUN echo 'npm run dev'
RUN npm run prod


COPY ./scripts/init-prod.sh /init-prod.sh
RUN chmod a+x /init-prod.sh
ENTRYPOINT ["/init-prod.sh"]
EXPOSE 9000

