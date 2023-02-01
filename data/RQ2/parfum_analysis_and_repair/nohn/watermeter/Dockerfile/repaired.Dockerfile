FROM php:8.1.7-cli
RUN apt-get update \
    && apt-get install --no-install-recommends -y libmagickwand-dev tesseract-ocr \
    && pecl install imagick \
    && docker-php-ext-enable imagick && rm -rf /var/lib/apt/lists/*;
COPY ./classes     /usr/src/watermeter/classes
COPY ./log        /usr/src/watermeter/log
COPY ./public     /usr/src/watermeter/public
COPY ./src        /usr/src/watermeter/src
COPY ./vendor     /usr/src/watermeter/vendor
WORKDIR /usr/src/watermeter/public
CMD [ "php", "-S", "0.0.0.0:3000" ]