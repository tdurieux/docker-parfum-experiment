FROM php:5.6-cli-alpine

# COPY INSTALL SCRIPTS
COPY ./image/*.sh /tmp/
COPY ./image/5.6/alpine/*.sh /tmp/
RUN chmod +x /tmp/*.sh

COPY ./image/php.ini /usr/local/etc/php/

WORKDIR /tmp

RUN sh ./env.sh && \
    sh ./apk.sh && \
    sh ./composer.sh && \
    sh ./qa.sh && \
    sh ./register.sh && \
    sh ./apk-clean.sh

WORKDIR /app
