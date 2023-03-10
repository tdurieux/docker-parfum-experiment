ARG PHP_VERSION
FROM bref/build-php-$PHP_VERSION as build_extensions

RUN pecl install xdebug
RUN cp $(php -r "echo ini_get('extension_dir');")/xdebug.so /tmp

RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -f -A "Docker" -o /tmp/blackfire.so -L -s "https://packages.blackfire.io/binaries/blackfire-php/1.55.0/blackfire-php-linux_amd64-php-"$version".so";

FROM bref/php-${PHP_VERSION}-fpm as build_dev

USER root
COPY --from=build_extensions /tmp/*.so /tmp/
RUN cp /tmp/*.so $(php -r "echo ini_get('extension_dir');")

FROM bref/php-${PHP_VERSION}-fpm

COPY --from=build_dev  /opt /opt
# Override the config so that PHP-FPM listens on port 9000
COPY php-fpm.conf /opt/bref/etc/php-fpm.conf

EXPOSE 9001

# Clear the parent entrypoint
ENTRYPOINT []

ENV PHP_INI_SCAN_DIR="/opt/bref/etc/php/conf.d:/var/task/php/conf.d:/var/task/php/conf.dev.d"

# Run PHP-FPM
# opcache.validate_timestamps=1 : cancels the flag in the base configuration so that files are reloaded
CMD /opt/bin/php-fpm --nodaemonize --fpm-config /opt/bref/etc/php-fpm.conf -d opcache.validate_timestamps=1 --force-stderr
