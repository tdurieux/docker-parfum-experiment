FROM php:7.4-cli-alpine
RUN apk update && \
  apk add --no-cache postgresql-dev && \
  docker-php-ext-install pdo_pgsql
