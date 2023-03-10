ARG CLI_IMAGE
FROM ${CLI_IMAGE} as cli

FROM uselagoon/php-7.4-fpm

RUN apk add --no-cache gmp gmp-dev \
    && docker-php-ext-install gmp \
    && docker-php-ext-configure gmp

COPY --from=cli /app /app
