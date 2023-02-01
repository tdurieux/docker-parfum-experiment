ARG PHP_VERSION=7.4
FROM php:${PHP_VERSION}-cli

ARG GITHUB_TOKEN

COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp

RUN apt-get update && apt-get install unzip tar git -y
RUN echo "phar.readonly=0" > /usr/local/etc/php/conf.d/phar.ini
RUN if [ -n "$GITHUB_TOKEN" ]; then \
      composer config github-oauth.github.com $GITHUB_TOKEN; \
    fi
RUN if [ -d vendor ]; then \
      rm -rf vendor; \
    fi \
    && composer install --no-dev --prefer-dist

CMD [ "./vendor/bin/drutiny" ]
