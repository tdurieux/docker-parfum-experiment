# syntax=docker/dockerfile:experimental
FROM wyrihaximusnet/php:7.4-nts-alpine-dev-root AS install-dependencies
RUN mkdir /workdir
COPY ./composer.* /workdir/
WORKDIR /workdir
RUN composer install --ansi --no-progress --no-interaction --prefer-dist

## Compile runtime image
FROM wyrihaximusnet/php:7.4-nts-alpine-root AS runtime
RUN mkdir /workdir
WORKDIR /workdir
COPY ./src /workdir/src
COPY ./composer.* ./wait.php /workdir/
COPY --from=install-dependencies /workdir/vendor/ /workdir/vendor/
RUN ls -lasth ./
ENTRYPOINT ["php", "/workdir/wait.php"]