FROM alpine

RUN apk add --no-cache \
  curl \
  php \
  php-curl \
  php-json \
  php-mbstring \
  php-phar \
  php-xml \
  && curl -f https://github.com/acquia/cli/releases/latest/download/acli.phar -L -o /usr/local/bin/acli \
  && chmod +x /usr/local/bin/acli
