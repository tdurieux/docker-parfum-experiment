FROM php:7.1-fpm

RUN apt-get update -yq \
    && apt-get install --no-install-recommends curl nano git gnupg -yq \
    && curl -f -sL https://deb.nodesource.com/setup_8.x | bash \
    && apt-get install --no-install-recommends nodejs -yq && rm -rf /var/lib/apt/lists/*;

RUN npm install forever -g && npm cache clean --force;

RUN curl -f -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev && docker-php-ext-install pdo pdo_pgsql mbstring && rm -rf /var/lib/apt/lists/*;

ADD . /var/www
COPY ./.env.prod /var/www/.env
ADD ./public /var/www/html
COPY ./docker-entrypoint.sh /var/www/html/docker-entrypoint.sh

RUN chown -R www-data:www-data /var/www && chown -R www-data:www-data /var/www/html

EXPOSE 9000
ENTRYPOINT sh docker-entrypoint.sh
