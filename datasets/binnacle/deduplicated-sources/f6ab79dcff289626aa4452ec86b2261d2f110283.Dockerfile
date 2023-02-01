FROM amelia/php:7.2 as build

COPY ./frontend /srv/code
COPY ./models /srv/code/app/Models
COPY ./config /srv/code/config
COPY ./database /srv/code/database
COPY ./bootstrap /srv/code/bootstrap

RUN composer install \
    && php artisan route:cache \
    && php artisan view:clear \
    && php artisan storage:link \
    && rm -rf /var/cache/composer/* \
    && chown -R www-data:www-data storage bootstrap/cache

FROM node:9 as assets

COPY ./frontend /srv/code
COPY ./models /srv/code/app/Models
COPY ./config /srv/code/config
COPY ./database /srv/code/database
COPY ./bootstrap /srv/code/bootstrap

WORKDIR /srv/code

RUN npm install && npm run production

FROM amelia/php:7.2 as production

COPY --from=build /srv/code /srv/code
COPY --from=assets /srv/code/public/assets /srv/code/public/assets

RUN apk add --update ca-certificates \
    && update-ca-certificates \
    && composer install --no-dev \
    && chown -R www-data:www-data /srv/code \
    && rm -rf /var/cache/composer/* \
    && rm -rf /var/cache/apk/*
