# See https://github.com/docker-library/php/blob/4677ca134fe48d20c820a19becb99198824d78e3/7.0/fpm/Dockerfile
FROM roadiz/php74-nginx-alpine
MAINTAINER Ambroise Maupate <ambroise@rezo-zero.com>

ARG USER_UID=1000
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV APP_ENV=dev
ENV APP_CACHE=0

RUN apk add --no-cache shadow make git \
    && usermod -u ${USER_UID} www-data \
    && groupmod -g ${USER_UID} www-data \
    && composer --version \
    && ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime \
    && "date"

# Display errors