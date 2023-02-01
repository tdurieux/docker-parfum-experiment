FROM php:7.4.4-apache

ARG CERT_URL

ENV PROJECT_DIR=/var/www/html \
    APP_URL=localhost \
    VENDOR_DIR=/var/www/vendor \
    DATA_DIR=/var/www/data

RUN docker-php-ext-install mysqli gettext gd

COPY ./src $PROJECT_DIR
COPY ./vendor $VENDOR_DIR
COPY ./data $DATA_DIR

# Adding Certs
RUN if [ -n "$CERT_URL" ]; then \
 curl -f -sL $CERT_URL | bash -; fi

COPY docker-entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r//' /entrypoint.sh

VOLUME $PROJECT_DIR/storage

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["run"]
