FROM php:7.4-apache

# Install PDO MySQL + OPcache
RUN set -eux; \
    docker-php-ext-install -j$(nproc) pdo_mysql; \
    docker-php-ext-enable opcache

# Install ddtrace
ARG ddtracePkgUrl
RUN set -eux; \
    cd ${HOME}; \
    curl -f -L "${ddtracePkgUrl}" -o ./ddtrace.deb; \
    dpkg -i ddtrace.deb;

ENV APACHE_DOCUMENT_ROOT /var/www/html/app
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

#ENV APACHE_LOG_DIR /var/www/html
#RUN set -eux; \
#    sed -e 's!ErrorLog $.*!ErrorLog /var/www/html/my_error.log!g' -i /etc/apache2/sites-available/*.conf;

# SetEnv test
RUN set -eux; \
    echo "SetEnv TEST_ENV 'myword!'" >> /etc/apache2/sites-available/000-default.conf
