FROM php:8.1-cli

COPY . /app
WORKDIR /app

RUN apt update && apt install --no-install-recommends -y git zip unzip && rm -rf /var/lib/apt/lists/*;

RUN php -r "copy('https://getcomposer.org/download/2.1.12/composer.phar', 'composer.phar');" \
 && chmod +x ./composer.phar \
 && ./composer.phar install

ENTRYPOINT ["/app/entrypoint.sh"]
