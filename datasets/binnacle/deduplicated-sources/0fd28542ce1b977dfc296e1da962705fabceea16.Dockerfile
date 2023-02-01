ARG INSTALL_CRON=1
ARG INSTALL_COMPOSER=1
FROM thecodingmachine/php:7.3-v2-slim-apache

LABEL authors="Julien Neuhart <j.neuhart@thecodingmachine.com>, David Négrier <d.negrier@thecodingmachine.com>"


# |--------------------------------------------------------------------------
# | Main PHP extensions
# |--------------------------------------------------------------------------
# |
# | Installs the main PHP extensions
# |

USER root
RUN cd /usr/local/lib/thecodingmachine-php/extensions/current/ && ./install_all.sh && ./disable_all.sh
USER docker

# |--------------------------------------------------------------------------
# | Default PHP extensions to be enabled
# |--------------------------------------------------------------------------
ENV PHP_EXTENSION_APCU=1 \
    PHP_EXTENSION_MYSQLI=1 \
    PHP_EXTENSION_OPCACHE=1 \
    PHP_EXTENSION_PDO=1 \
    PHP_EXTENSION_PDO_MYSQL=1 \
    PHP_EXTENSION_REDIS=1 \
    PHP_EXTENSION_ZIP=1 \
    PHP_EXTENSION_SOAP=1

